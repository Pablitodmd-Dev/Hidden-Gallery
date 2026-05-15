extends Area2D

var target_index = -1
var is_dragging = false
var is_locked = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func setup_piece(p_index, p_texture, p_region, p_scale):
	target_index = p_index
	var atlas = AtlasTexture.new()
	atlas.atlas = p_texture
	atlas.region = p_region
	sprite.texture = atlas
	sprite.scale = p_scale
	
	if collision.shape:
		collision.shape.size = p_region.size * p_scale

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
				break
