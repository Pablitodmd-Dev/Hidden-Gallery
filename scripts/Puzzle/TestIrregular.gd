extends Node2D

@onready var chart = $Chart
@onready var cell_container = $Cells
@onready var piece_container = $Pieces
@onready var complete_sound = $CompleteSound

@onready var cell_scene = preload("res://scenes/Puzzle/CellIrregular.tscn")
@onready var piece_scene = preload("res://scenes/Puzzle/PuzzlePieceIrregular.tscn")

@onready var hint_image = $HintImage
@onready var hint_button = $HintButton

var TARGET_W: float = 920.0
var TARGET_H: float = 546.0

func _ready():
	cell_container.global_position = chart.global_position
	piece_container.global_position = chart.global_position
	
	hint_image.texture = G.next_texture
	hint_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hint_image.stretch_mode = TextureRect.STRETCH_SCALE
	hint_image.visible = false

	hint_button.pressed.connect(_on_hint_button_pressed)
	hint_button.text = "View Hint"
	
	if G.next_texture:
		start_game()

func _on_hint_button_pressed():
	hint_image.visible = not hint_image.visible
	hint_button.text = "Hide Hint" if hint_image.visible else "View Hint"

func start_game():
	G.reset_puzzle_data()
	
	var texture = G.next_texture
	var cols = G.next_columns
	var rows = G.next_rows
	
	var scale_x = TARGET_W / texture.get_width()
	var scale_y = TARGET_H / texture.get_height()
	var final_scale_vector = Vector2(scale_x, scale_y)
	
	var unit_w = TARGET_W / cols
	var unit_h = TARGET_H / rows
	
	var start_offset = -(Vector2(TARGET_W, TARGET_H) / 2)
	
	var orig_u_w = texture.get_width() / float(cols)
	var orig_u_h = texture.get_height() / float(rows)
	
	for y in range(rows):
		for x in range(cols):
			var base_idx = ((y * cols) + x) * 2 
			
			var tl_local = start_offset + Vector2(x * unit_w, y * unit_h)
			var tr_local = start_offset + Vector2((x + 1) * unit_w, y * unit_h)
			var br_local = start_offset + Vector2((x + 1) * unit_w, (y + 1) * unit_h)
			var bl_local = start_offset + Vector2(x * unit_w, (y + 1) * unit_h)
			
			var tl_uv = Vector2(x * orig_u_w, y * orig_u_h)
			var tr_uv = Vector2((x + 1) * orig_u_w, y * orig_u_h)
			var br_uv = Vector2((x + 1) * orig_u_w, (y + 1) * orig_u_h)
			var bl_uv = Vector2(x * orig_u_w, (y + 1) * orig_u_h)
			
			var points_a = PackedVector2Array([tl_uv, tr_uv, bl_uv])
			var center_a = (tl_local + tr_local + bl_local) / 3.0
			_create_puzzle_element(base_idx, texture, final_scale_vector, points_a, center_a)
			
			var points_b = PackedVector2Array([tr_uv, br_uv, bl_uv])
			var center_b = (tr_local + br_local + bl_local) / 3.0
			_create_puzzle_element(base_idx + 1, texture, final_scale_vector, points_b, center_b)

func _create_puzzle_element(idx: int, texture: Texture2D, scale_vector: Vector2, points: PackedVector2Array, target_center: Vector2):
	var center = Vector2.ZERO
	for pt in points:
		center += pt
	center /= points.size()
	
	var centered_points = PackedVector2Array()
	for pt in points:
		centered_points.append((pt - center) * scale_vector)

	var cell = cell_scene.instantiate()
	cell_container.add_child(cell)
	cell.position = target_center
	cell.setup_cell(idx, centered_points)
	G.cells.append(cell)
	
	var piece = piece_scene.instantiate()
	piece_container.add_child(piece)
	
	var side = 1 if randf() > 0.5 else -1
	piece.position = Vector2(side * randf_range(600, 800), randf_range(-300, 300))
	
	piece.setup_piece(idx, texture, scale_vector, points)
	
	var angles = [0, 90, 180, 270]
	piece.rotation_degrees = angles.pick_random()
	
	piece.piece_locked.connect(_on_piece_locked)
	G.pieces.append(piece)

func _on_piece_locked():
	var all_locked = G.pieces.all(func(p): return p.is_locked)
	if all_locked:
		_on_puzzle_completed()

func _on_puzzle_completed():
	if complete_sound:
		complete_sound.play()
		
	hint_button.visible = false
	hint_image.visible = false
	
	if G.current_puzzle_id != "":
		GameManager.mark_puzzle_complete(G.current_puzzle_id)
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
