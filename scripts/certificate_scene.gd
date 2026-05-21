extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready() -> void:
	color_rect.visible = true
	if anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")
		await anim_player.animation_finished
	color_rect.visible = false
