class_name Player extends CharacterBody3D

@export_category("Movement")
@export var SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export_category("Weapons")
@export var wepon : Array = [ArrayMesh]


var _mouse_sensibility = 1200
var _mouse_relative_x = 0
var _mouse_relative_y = 0
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Head/Camera
@onready var gun_ray: RayCast3D = $Head/Camera/GunRay

func _ready() -> void:
	
	gun_ray.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= _gravity * delta
		
	_handle_input()

func _handle_input() -> void:
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
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
