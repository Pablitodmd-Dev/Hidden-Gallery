extends Node2D

@onready var chart = $Chart
@onready var cell_container = $Cells
@onready var piece_container = $Pieces
@onready var cell_scene = preload("res://scenes/Puzzle/Cell.tscn")
@onready var piece_scene = preload("res://scenes/Puzzle/PuzzlePiece.tscn")
@onready var complete_sound = $CompleteSound
@onready var hint_image = $HintImage
@onready var hint_button = $HintButton

var TARGET_W: float = 920.0
var TARGET_H: float = 546.0

const ROOM_SCENES = {
	"animal_1": "res://scenes/Rooms/AnimalsRoom.tscn",
	"animal_2": "res://scenes/Rooms/AnimalsRoom.tscn",
	"animal_3": "res://scenes/Rooms/AnimalsRoom.tscn",
	"flower_1": "res://scenes/Rooms/FlowerRoom.tscn",
	"flower_2": "res://scenes/Rooms/FlowerRoom.tscn",
	"landscape_1": "res://scenes/Rooms/LandscapeRoom.tscn",
	"landscape_2": "res://scenes/Rooms/LandscapeRoom.tscn",
}

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
	var scaled_unit_size = Vector2(unit_w, unit_h)

	var start_offset = -(Vector2(TARGET_W, TARGET_H) / 2)

	for y in range(rows):
		for x in range(cols):
			var idx = (y * cols) + x

			var cell = cell_scene.instantiate()
			cell_container.add_child(cell)
			cell.position = start_offset + Vector2(x * unit_w, y * unit_h) + (scaled_unit_size / 2)
			cell.setup_cell(idx, scaled_unit_size)
			G.cells.append(cell)

			var piece = piece_scene.instantiate()
			piece_container.add_child(piece)

			var side = 1 if randf() > 0.5 else -1
			piece.position = Vector2(side * randf_range(600, 800), randf_range(-300, 300))

			var orig_u_w = texture.get_width() / float(cols)
			var orig_u_h = texture.get_height() / float(rows)
			var region = Rect2(x * orig_u_w, y * orig_u_h, orig_u_w + 1.0, orig_u_h + 1.0)

			piece.setup_piece(idx, texture, region, final_scale_vector)

			var angles = [0, 90, 180, 270]
			piece.rotation_degrees = angles.pick_random()

			piece.piece_locked.connect(_on_piece_locked)
			G.pieces.append(piece)

func _on_piece_locked():
	var all_locked = G.pieces.all(func(p): return p.is_locked)
	if all_locked:
		_on_puzzle_completed()

func _on_puzzle_completed():
	complete_sound.play()
	hint_button.visible = false
	hint_image.visible = false

	GameManager.mark_puzzle_complete(G.current_puzzle_id)

	await get_tree().create_timer(1.5).timeout

	var next_scene = ROOM_SCENES.get(G.current_puzzle_id, "res://scenes/Rooms/PrincipalRoom.tscn")
	get_tree().change_scene_to_file(next_scene)
