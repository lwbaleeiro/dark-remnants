extends CenterContainer

@export var reticle_lines : Array[Line2D]
@export var player_controller : CharacterBody3D
@export var reticle_speed : float = 0.25
@export var reticle_distance : float = 2.0
@export var dot_radius : float = 1.0
@export var dot_color : Color = Color.WHITE

func _ready() -> void:
	queue_redraw()
	
func _process(_delta: float) -> void:
	adjuste_reticle_lines()

func _draw() -> void:
	draw_circle(Vector2(0,0), dot_radius, dot_color)

func adjuste_reticle_lines():
	
	var velocity = player_controller.get_real_velocity()
	var origin = Vector3(0,0,0)
	var pos = Vector2(0,0)
	var speed = origin.distance_to(velocity)

	reticle_lines[0].position = lerp(reticle_lines[0].position, pos + Vector2(0, -speed * reticle_distance), reticle_speed)
	reticle_lines[1].position = lerp(reticle_lines[1].position, pos + Vector2(speed * reticle_distance, 0), reticle_speed)
	reticle_lines[2].position = lerp(reticle_lines[2].position, pos + Vector2(0, speed * reticle_distance), reticle_speed)
	reticle_lines[3].position = lerp(reticle_lines[3].position, pos + Vector2(-speed * reticle_distance, 0), reticle_speed)
