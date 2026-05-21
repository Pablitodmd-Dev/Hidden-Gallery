extends Node2D

@onready var audio_player = $ChartsSounds
@onready var camera = $PrincipalZoom
@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var background_cleaned = $BackgroundCleaned
@onready var secret_room_door = $SecretRoomDoor

func _ready():
	background_cleaned.visible = GameManager.all_main_puzzles_done()
	secret_room_door.input_pickable = GameManager.all_main_puzzles_done()

	color_rect.visible = true
	if anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")
		await anim_player.animation_finished
		color_rect.visible = false
	else:
		color_rect.visible = false

func transition_to_room(marker_node: Marker2D, target_scene: String):
	set_process_input(false)
	color_rect.visible = true

	var target_pos = marker_node.global_position
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(camera, "zoom", Vector2(2.2, 2.2), 1.2)
	tween.tween_property(camera, "global_position", target_pos, 1.2)

	anim_player.play("fade_out")

	$StepsSound.play()
	await $StepsSound.finished
	$StepsSound.play()

	if anim_player.is_playing():
		await anim_player.animation_finished

	get_tree().change_scene_to_file(target_scene)

func transition_to_room_fade_only(target_scene: String):
	set_process_input(false)
	color_rect.visible = true

	anim_player.play("fade_out_2")
	await anim_player.animation_finished

	get_tree().change_scene_to_file(target_scene)

func _on_animals_door_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		transition_to_room($AnimalsDoor/AnimalCameraPoint, "res://scenes/Rooms/AnimalsRoom.tscn")

func _on_land_scapes_door_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		transition_to_room($LandScapesDoor/LandscapeCameraPoint, "res://scenes/Rooms/LandscapeRoom.tscn")

func _on_flora_door_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		transition_to_room($FloraDoor/FloraCameraPoint, "res://scenes/Rooms/FlowerRoom.tscn")

func _on_secret_room_door_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		transition_to_room_fade_only("res://scenes/Rooms/SecretRoom.tscn")

func _on_animals_chart_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		audio_player.stream = preload("res://assets/Sounds/sfx/AnimalSound.mp3")
		audio_player.play()

func _on_flora_chart_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		audio_player.stream = preload("res://assets/Sounds/sfx/flowerSound.mp3")
		audio_player.play()

func _on_land_scape_chart_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.pressed:
		audio_player.stream = preload("res://assets/Sounds/sfx/landscapeSound.wav")
		audio_player.play()
