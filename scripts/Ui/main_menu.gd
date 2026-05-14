extends Control

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
