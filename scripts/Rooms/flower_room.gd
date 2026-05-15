extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

@onready var flower1_complete = $Flora1ChartComplete
@onready var flower2_complete = $Flora2ChartComplete

@onready var floral_chart_1 = $FloralChart1
@onready var floral_chart_2 = $FloralChart2

@onready var cleared_image = $CleanedImage

@export var texture_flower_1: Texture2D
@export var texture_flower_2: Texture2D

func _ready() -> void:
	flower1_complete.visible = GameManager.Flower_Puzzle_1
	flower2_complete.visible = GameManager.Flower_Puzzle_2

	floral_chart_1.input_pickable = not GameManager.Flower_Puzzle_1
	floral_chart_2.input_pickable = not GameManager.Flower_Puzzle_2

	cleared_image.visible = GameManager.all_flower_puzzles_done()

	color_rect.visible = true
	if anim_player.has_animation("entering_scene"):
		anim_player.play("entering_scene")
		await anim_player.animation_finished
	color_rect.visible = false

func _start_puzzle_transition(tex: Texture2D, puzzle_id: String) -> void:
	if tex == null:
		return
	G.set_next_puzzle(tex, 4, 2, puzzle_id)

	color_rect.visible = true
	if anim_player.has_animation("leaving_scene"):
		anim_player.play("leaving_scene")
		await anim_player.animation_finished

	get_tree().change_scene_to_file("res://scenes/Puzzle/Test.tscn")

func _on_floral_chart_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_flower_1, "flower_1")

func _on_floral_chart_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_flower_2, "flower_2")

func _on_texture_button_pressed() -> void:
	color_rect.visible = true
	if anim_player.has_animation("leaving_scene"):
		anim_player.play("leaving_scene")
		await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
