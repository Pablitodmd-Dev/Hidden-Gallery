extends Control

func _on_texture_button_pressed() -> void:
	$Pop.play()
	await $Pop.finished
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
