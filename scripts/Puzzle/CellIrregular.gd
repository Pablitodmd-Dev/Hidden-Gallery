extends Area2D

var index = -1

@onready var polygon = $Polygon2D
@onready var collision_polygon = $CollisionPolygon2D 

func setup_cell(p_index: int, p_points: PackedVector2Array):
	index = p_index
	
	if polygon:
		polygon.polygon = p_points
		polygon.color = Color(1, 1, 1, 0.1)
		
	if collision_polygon:
		collision_polygon.polygon = p_points

func _on_mouse_entered() -> void:
	polygon.color = Color(0.4, 0.4, 0.4, 0.3)

func _on_mouse_exited() -> void:
	polygon.color = Color(1, 1, 1, 0.1)
