extends Control

func _ready():
	Dialogic.start("intro")
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("intro")

func _on_dialogic_signal(argument):
	if argument == "intro_finished":
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
