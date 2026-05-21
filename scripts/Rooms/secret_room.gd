extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var history1_complete = $HistoryChart1Complete
@onready var history2_complete = $HistoryChart2Complete
@onready var history_chart_1 = $HistoryChart1
@onready var history_chart_2 = $HistoryChart2
@onready var cleaned_image = $CleanedImage
@onready var certificate = $Certificate

@export var texture_history_1: Texture2D
@export var texture_history_2: Texture2D

func _ready() -> void:
	history1_complete.visible = GameManager.History_puzzle_1
	history2_complete.visible = GameManager.History_puzzle_2
	history_chart_1.input_pickable = not GameManager.History_puzzle_1
	history_chart_2.input_pickable = not GameManager.History_puzzle_2
	cleaned_image.visible = GameManager.all_history_puzzles_done()

	certificate.visible = GameManager.all_puzzles_done()
	certificate.input_pickable = GameManager.all_puzzles_done()

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
	if anim_player.has_animation("entering_puzzle"):
		anim_player.play("entering_puzzle")
		await anim_player.animation_finished

	get_tree().change_scene_to_file("res://scenes/Puzzle/TestIrregular.tscn")

func _on_history_chart_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_history_1, "history_1")

func _on_history_chart_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_history_2, "history_2")

func _on_certificate_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		color_rect.visible = true
		if anim_player.has_animation("leaving_scene"):
			anim_player.play("leaving_scene")
			await anim_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/CertificateScene.tscn")

func _on_texture_button_pressed() -> void:
	color_rect.visible = true
	if anim_player.has_animation("leaving_scene"):
		anim_player.play("leaving_scene")
		await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
