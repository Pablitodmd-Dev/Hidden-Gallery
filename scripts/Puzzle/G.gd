extends Node

var next_texture: Texture2D
var next_columns: int = 4
var next_rows: int = 2
var cells = []
var pieces = []
var is_any_piece_dragging = false
var current_puzzle_id: String = ""

func reset_puzzle_data():
	cells.clear()
	pieces.clear()
	is_any_piece_dragging = false

func set_next_puzzle(tex: Texture2D, cols: int, rs: int, puzzle_id: String = ""):
	next_texture = tex
	next_columns = cols
	next_rows = rs
	current_puzzle_id = puzzle_id
