extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready() -> void:
	color_rect.visible = true
	
	if anim_player.has_animation("entering_scene"):
		anim_player.play("entering_scene")
		await anim_player.animation_finished
		color_rect.visible = false
	else:
		color_rect.visible = false

func _on_texture_button_pressed() -> void:
	color_rect.visible = true
	
	if anim_player.has_animation("leaving_scene"):
		anim_player.play("leaving_scene")
		await anim_player.animation_finished
		
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
