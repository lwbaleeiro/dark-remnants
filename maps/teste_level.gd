extends Node3D

@onready var spawns: Node3D = $Spawns
@onready var navigation_region: NavigationRegion3D = $NavigationRegion3D

var zombie = load("res://enemys/teste_enemy.tscn")
var zombie_instance

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	pass

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_spawn_timer_timeout() -> void:
	var spawn_point = _get_random_child(spawns).global_position
	zombie_instance = zombie.instantiate()
	zombie_instance.position = spawn_point
	navigation_region.add_child(zombie_instance)
