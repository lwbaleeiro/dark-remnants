class_name Player extends CharacterBody3D

@export_category("Movement")
@export var SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export_category("Weapons")
@export var weapons : Array[Weapon]

var _base_weapon_index = 0
var _base_weapon

var _mouse_sensibility = 1200
var _mouse_relative_x = 0
var _mouse_relative_y = 0
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Head/Camera
@onready var weapon_rig: Node3D = $Head/Camera/WeaponRig
@onready var ray_cast: RayCast3D = $Head/Camera/RayCast
@onready var fire_rate: Timer = $FireRate

func _ready() -> void:
	
	ray_cast.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	load_weapon()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= _gravity * delta
		
	_handle_input()

func _handle_input() -> void:
	
	if Input.is_action_pressed("shoot"):
		attack()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("change_weapon"):
		_base_weapon_index += 1
		load_weapon()
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / _mouse_sensibility
		camera.rotation.x -= event.relative.y / _mouse_sensibility
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		_mouse_relative_x = clamp(event.relative.x, -50, 50)
		_mouse_relative_y = clamp(event.relative.y, -50, 10)

func load_weapon() -> void:
	_base_weapon = weapons[_base_weapon_index]
	var weapon_scene = _base_weapon.scene
	weapon_rig.add_child(weapon_scene.instantiate())

func attack() -> void:
	if fire_rate.is_stopped():
		fire_rate.start(_base_weapon.fire_rate)
		
		for shoot in _base_weapon.shot_count:
			ray_cast.target_position.x = randf_range(-_base_weapon.spread, _base_weapon.spread)
			ray_cast.target_position.y = randf_range(-_base_weapon.spread, _base_weapon.spread)
		
			ray_cast.force_raycast_update()
			if !ray_cast.is_colliding(): continue
			
			var collider = ray_cast.get_collider()
			
			if collider.has_method("damage"):
				collider.damage(_base_weapon.damage)
			
			var impact = preload("res://weapons/effects/impact.tscn")
			var impact_instance = impact.instantiate()
			
			get_tree().root.add_child(impact_instance)
			impact_instance.position = ray_cast.get_collision_point() + (ray_cast.get_collision_normal() / 10)
			impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true)
