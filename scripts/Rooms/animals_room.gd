extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

# Nodos de puzzles completados
@onready var animal1_complete = $Animal1ChartComplete
@onready var animal2_complete = $Animal2ChartComplete
@onready var animal3_complete = $Animal3ChartComplete

# Nodos de puzzles (para deshabilitar click si ya completados)
@onready var animal1_chart = $AnimalChart1
@onready var animal2_chart = $AnimalChart2
@onready var animal3_chart = $AnimalChart3

# Nodo recompensa al completar los 3 puzzles
@onready var cleared_image = $CleanedImage

@export var texture_animal_1: Texture2D
@export var texture_animal_2: Texture2D
@export var texture_animal_3: Texture2D

func _ready() -> void:
	animal1_complete.visible = GameManager.Animal_puzzle_1
	animal2_complete.visible = GameManager.Animal_puzzle_2
	animal3_complete.visible = GameManager.Animal_puzzle_3

	animal1_chart.input_pickable = not GameManager.Animal_puzzle_1
	animal2_chart.input_pickable = not GameManager.Animal_puzzle_2
	animal3_chart.input_pickable = not GameManager.Animal_puzzle_3

	cleared_image.visible = GameManager.all_animal_puzzles_done()

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

	get_tree().change_scene_to_file("res://scenes/Puzzle/Test.tscn")

func _on_animal_chart_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_animal_1, "animal_1")

func _on_animal_chart_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_animal_2, "animal_2")

func _on_animal_chart_3_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_puzzle_transition(texture_animal_3, "animal_3")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
