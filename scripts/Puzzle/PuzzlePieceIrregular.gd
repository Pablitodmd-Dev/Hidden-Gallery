extends Area2D

signal piece_locked

var target_index = -1
var is_dragging = false
var is_locked = false

@onready var polygon = $Polygon
@onready var collision_polygon = $CollisionPolygon

func setup_piece(p_index, p_texture, p_scale, p_points: PackedVector2Array):
	target_index = p_index
	
	polygon.texture = p_texture
	
	polygon.uv = p_points
	
	var center = Vector2.ZERO
	for pt in p_points:
		center += pt
	center /= p_points.size()
	
	var centered_points = PackedVector2Array()
	for pt in p_points:
		centered_points.append((pt - center) * p_scale)
	
	polygon.polygon = centered_points
	collision_polygon.polygon = centered_points

func _input(event):
	if is_dragging and event.is_action_pressed("rotate_piece"):
		rotation_degrees = fmod(rotation_degrees + 90, 360)

func _input_event(_viewport, event, _idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_locked:
			if G.is_any_piece_dragging:
				return
			is_dragging = true
			G.is_any_piece_dragging = true
			z_index = 20
			get_viewport().set_input_as_handled()
			
		elif not event.pressed and is_dragging:
			is_dragging = false
			G.is_any_piece_dragging = false
			z_index = 0
			check_distance()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position()

func check_distance():
	for cell in G.cells:
		if global_position.distance_to(cell.global_position) < 60:
			var current_rot = abs(fmod(rotation_degrees, 360))
			if cell.index == target_index and (current_rot < 0.1 or current_rot > 359.9):
				global_position = cell.global_position
				rotation_degrees = 0
				is_locked = true
				z_index = 1
				emit_signal("piece_locked")
				break
