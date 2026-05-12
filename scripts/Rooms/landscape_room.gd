extends Control

@onready var anim_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready() -> void:
	# 1. Al entrar, activamos el ColorRect para que empiece tapando la vista
	color_rect.visible = true
	
	# 2. Reproducimos la animación de entrada (Negro -> Transparente)
	if anim_player.has_animation("entering_scene"):
		anim_player.play("entering_scene")
		# Esperamos a que termine antes de ocultar el nodo
		await anim_player.animation_finished
		color_rect.visible = false
	else:
		# Si la animación no existe, lo ocultamos para poder interactuar
		color_rect.visible = false

func _on_texture_button_pressed() -> void:
	# 1. Bloqueamos el botón (opcional, para evitar múltiples clics)
	# self.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	
	# 2. Hacemos visible el color_rect para el fundido de salida
	color_rect.visible = true
	
	# 3. Reproducimos la animación de salida (Transparente -> Negro)
	if anim_player.has_animation("leaving_scene"):
		anim_player.play("leaving_scene")
		# ESPERAMOS a que la pantalla esté totalmente negra
		await anim_player.animation_finished
	
	# 4. Cambiamos a la sala principal
	get_tree().change_scene_to_file("res://scenes/Rooms/PrincipalRoom.tscn")
