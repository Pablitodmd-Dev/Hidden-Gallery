extends Node2D 

@onready var audio_player = $AudioStreamPlayer2D 

var sound_animals = preload("res://assets/Sounds/sfx/AnimalSound.mp3")
var sound_flora = preload("res://assets/Sounds/sfx/flowerSound.mp3")
var sound_landscapes = preload("res://assets/Sounds/sfx/landscapeSound.wav")

func _on_animals_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/Rooms/AnimalsRoom.tscn")

func _on_land_scapes_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/Rooms/LandscapeRoom.tscn")

func _on_flora_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/Rooms/FlowerRoom.tscn")

func _on_animals_chart_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		audio_player.stream = sound_animals
		audio_player.play()

func _on_flora_chart_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		audio_player.stream = sound_flora
		audio_player.play()

func _on_land_scape_chart_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		audio_player.stream = sound_landscapes
		audio_player.play()
