extends SubViewport

var scree_size : Vector2

func _ready() -> void:
	scree_size = get_window().size
	size = scree_size
