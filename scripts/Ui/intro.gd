extends Control

@onready var rain = $Rain

func _ready():
	MusicPlayer.stop()
	
	rain.play()
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("intro")

func _on_dialogic_signal(argument):
	if argument == "intro_finished":
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
		rain.stop()
		MusicPlayer.play()
