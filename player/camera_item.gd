extends Camera3D

@export var MAIN_CAMERA : Node3D

func _process(_delta: float) -> void:
	global_transform = MAIN_CAMERA.global_transform
