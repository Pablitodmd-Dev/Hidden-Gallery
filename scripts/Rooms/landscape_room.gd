extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

@onready var landscape1_complete = $Landscape1ChartComplete
@onready var landscape2_complete = $Landscape2ChartComplete

@onready var landscape_chart_1 = $LandscapeChart1
@onready var landscape_chart_2 = $LandscapeChart2

@onready var cleared_image = $CleanedImage

@export var texture_landscape_1: Texture2D
@export var texture_landscape_2: Texture2D

func _ready() -> void:
	landscape1_complete.visible = GameManager.Landscape_Puzzle_1
	landscape2_complete.visible = GameManager.Landscape_Puzzle_2

	landscape_chart_1.input_pickable = not GameManager.Landscape_Puzzle_1
	landscape_chart_2.input_pickable = not GameManager.Landscape_Puzzle_2

	cleared_image.visible = GameManager.all_landscape_puzzles_done()

	color_rect.visible = true
	if anim_player.has_animation("entering_scene"):
		anim_player.play("entering_scene")
		await anim_player.animation_finished
		color_rect.visible = false
	else:
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

func _on_landscape_chart_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_landscape_1, "landscape_1")

func _on_landscape_chart_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_landscape_2, "landscape_2")

func _on_texture_button_pressed() -> void:
	color_rect.visible = true
	if anim_player.has_animation("leaving_scene"):
		anim_player.play("leaving_scene")
		await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
