extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready() -> void:
	color_rect.visible = true
	if anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")
		await anim_player.animation_finished
	color_rect.visible = false
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("certificate")

func _on_dialogic_signal(argument):
	if argument == "certificate_finished":
		await get_tree().create_timer(2.0).timeout
		color_rect.visible = true
		if anim_player.has_animation("fade_out"):
			anim_player.play("fade_out")
			await anim_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
