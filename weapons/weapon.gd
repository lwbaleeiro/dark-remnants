class_name Weapon extends Resource

@export_category("Model")
@export var name : StringName
@export var scene : PackedScene
@export var mesh : Mesh
@export var position : Vector3
@export var rotation : Vector3
@export var scale : Vector3

@export_category("Weapon Properties")
@export_range(0.1, 1) var fire_rate : float = 0.1
@export_range(1, 20) var max_distance : float = 10
@export_range(0, 100) var damage : float = 25
@export_range(0, 5) var spread : float = 0
@export_range(1, 5) var shot_count : int = 1
@export_range(0, 50) var knockback : int = 20

@export_category("Sounds")
@export var sound_shoot : String
