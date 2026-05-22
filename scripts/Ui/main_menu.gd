extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready() -> void:
	var backgroundMusic = load("res://assets/Sounds/bgMusic/RelaxingPiano.mp3")
	
	if BgMusic != null:
		if BgMusic.stream != backgroundMusic:
			BgMusic.stream = backgroundMusic
			BgMusic.volume_db = -25.0
			BgMusic.play()

	color_rect.visible = true
	if anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")
		await anim_player.animation_finished
	color_rect.visible = false

func _on_play_pressed() -> void:
	$Pop.play()
	await $Pop.finished
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")

func _on_controls_pressed() -> void:
	$Pop.play()
	await $Pop.finished
	get_tree().change_scene_to_file("res://scenes/ui/Controls.tscn")

func _on_exit_pressed() -> void:
	$Pop.play()
	await $Pop.finished
	get_tree().quit()
