extends Node2D

@onready var cell_container = find_child("Cells")
@onready var piece_container = find_child("Pieces")
@onready var cell_scene = preload("res://scenes/Puzzle/Cell.tscn")
@onready var piece_scene = preload("res://scenes/Puzzle/PuzzlePiece.tscn")

func _ready():
	if cell_container and piece_container:
		start_game()

func start_game():
	var texture = G.get_image()
	var scale_factor = G.target_width / texture.get_width()
	
	var unit_width = texture.get_width() / G.columns
	var unit_height = texture.get_height() / G.rows
	var scaled_unit_size = Vector2(unit_width, unit_height) * scale_factor

	for y in range(G.rows):
		for x in range(G.columns):
			var idx = (y * G.columns) + x
			
			var cell = cell_scene.instantiate()
			cell_container.add_child(cell)
			cell.position = Vector2(x * scaled_unit_size.x, y * scaled_unit_size.y) + (scaled_unit_size / 2)
			cell.setup_cell(idx, scaled_unit_size)
			G.cells.append(cell)
			
			var piece = piece_scene.instantiate()
			piece_container.add_child(piece)
			piece.position = Vector2(randf_range(100, 700), randf_range(100, 500))
			var region = Rect2(x * unit_width, y * unit_height, unit_width, unit_height)
			piece.setup_piece(idx, texture, region, scale_factor)
