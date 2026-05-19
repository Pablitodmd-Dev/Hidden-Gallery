extends Node2D

@onready var chart = $Chart
@onready var cell_container = $Cells
@onready var piece_container = $Pieces
@onready var complete_sound = $CompleteSound

@onready var cell_scene = preload("res://scenes/Puzzle/Cell.tscn")
@onready var piece_scene = preload("res://scenes/Puzzle/PuzzlePieceIrregular.tscn")

var TARGET_W: float = 920.0
var TARGET_H: float = 546.0

const ROOM_SCENES = {
	"animal_1": "res://scenes/Rooms/AnimalsRoomIrregular.tscn",
	"animal_2": "res://scenes/Rooms/AnimalsRoomIrregular.tscn",
	"animal_3": "res://scenes/Rooms/AnimalsRoomIrregular.tscn"
}

func _ready():
	cell_container.global_position = chart.global_position
	piece_container.global_position = chart.global_position
	
	if G.next_texture:
		start_game()

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
	
	var orig_u_w = texture.get_width() / float(cols)
	var orig_u_h = texture.get_height() / float(rows)
	
	var jitter = 35.0
	var grid_points = []
	
	for y in range(rows + 1):
		var row_points = []
		for x in range(cols + 1):
			var base_point = Vector2(x * orig_u_w, y * orig_u_h)
			if x > 0 and x < cols and y > 0 and y < rows:
				base_point.x += randf_range(-jitter, jitter)
				base_point.y += randf_range(-jitter, jitter)
			row_points.append(base_point)
		grid_points.append(row_points)

	for y in range(rows):
		for x in range(cols):
			var idx = (y * cols) + x
			
			var cell = cell_scene.instantiate()
			cell_container.add_child(cell)
			cell.position = start_offset + Vector2(x * unit_w, y * unit_h) + (scaled_unit_size / 2)
			cell.setup_cell(idx, scaled_unit_size)
			G.cells.append(cell)
			
			var tl = grid_points[y][x]
			var tr = grid_points[y][x + 1]
			var br = grid_points[y + 1][x + 1]
			var bl = grid_points[y + 1][x]
			
			var edge_deformation = 45.0 
			
			var mid_top = (tl + tr) / 2.0
			if y > 0:
				mid_top += Vector2(randf_range(-10, 10), randf_range(-edge_deformation, edge_deformation))
			
			var mid_right = (tr + br) / 2.0
			if x < cols - 1:
				mid_right += Vector2(randf_range(-edge_deformation, edge_deformation), randf_range(-10, 10))
				
			var mid_bottom = (br + bl) / 2.0
			if y < rows - 1:
				mid_bottom += Vector2(randf_range(-10, 10), randf_range(-edge_deformation, edge_deformation))
				
			var mid_left = (bl + tl) / 2.0
			if x > 0:
				mid_left += Vector2(randf_range(-edge_deformation, edge_deformation), randf_range(-10, 10))
			
			var piece_points = PackedVector2Array([
				tl, mid_top, 
				tr, mid_right, 
				br, mid_bottom, 
				bl, mid_left
			])
			
			var piece = piece_scene.instantiate()
			piece_container.add_child(piece)
			
			var side = 1 if randf() > 0.5 else -1
			piece.position = Vector2(side * randf_range(600, 800), randf_range(-300, 300))
			
			piece.setup_piece(idx, texture, final_scale_vector, piece_points)
			
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
		
	GameManager.mark_puzzle_complete(G.current_puzzle_id)
	
	await get_tree().create_timer(1.5).timeout
	
	var next_scene = ROOM_SCENES.get(G.current_puzzle_id, "res://scenes/Rooms/PrincipalRoom.tscn")
	get_tree().change_scene_to_file(next_scene)
