extends CharacterBody3D

var player = null
const SPEED : float = 4.0
const ATTACK_RANGE : float = 2.5

@export var player_path := "/root/Level/NavigationRegion3D/Player"
@onready var nav_agent: NavigationAgent3D = $NavAgent

func _ready() -> void:
	player = get_node(player_path)

func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	if _target_in_range():
		print("atacou")
	
	move_and_slide()

func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
