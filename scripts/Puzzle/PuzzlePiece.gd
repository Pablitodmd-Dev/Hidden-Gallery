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
	sprite.scale = Vector2(p_scale, p_scale)
	if collision.shape:
		collision.shape.size = p_region.size * p_scale

func _input_event(_viewport, event, _idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_locked:
			is_dragging = true
			z_index = 10
		else:
			is_dragging = false
			z_index = 0
			check_distance()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position()

func check_distance():
	for cell in G.cells:
		if global_position.distance_to(cell.global_position) < 50:
			if cell.index == target_index:
				global_position = cell.global_position
				is_locked = true
				break
