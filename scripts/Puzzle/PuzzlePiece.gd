extends Area2D

var target_index = -1
var is_dragging = false
var is_locked = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

# Cambiamos p_scale para que acepte el Vector2 que enviamos desde el Test
func setup_piece(p_index, p_texture, p_region, p_scale):
	target_index = p_index
	var atlas = AtlasTexture.new()
	atlas.atlas = p_texture
	atlas.region = p_region
	sprite.texture = atlas
	
	# APLICAMOS EL VECTOR2 DIRECTAMENTE
	# Esto permite que la pieza se estire de forma independiente en X e Y
	sprite.scale = p_scale
	
	# AJUSTE DE COLISIÓN
	# Multiplicamos el tamaño original por el vector de escala para que 
	# el área de clic coincida exactamente con lo que ves en pantalla
	if collision.shape:
		collision.shape.size = p_region.size * p_scale

func _input_event(_viewport, event, _idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_locked:
			if G.is_any_piece_dragging:
				return
				
			is_dragging = true
			G.is_any_piece_dragging = true
			z_index = 20 # Súbelo a 20 para que esté por encima del marco (Chart)
			get_viewport().set_input_as_handled()
			
		elif not event.pressed and is_dragging:
			is_dragging = false
			G.is_any_piece_dragging = false
			z_index = 0
			check_distance()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position()

func check_distance():
	for cell in G.cells:
		# Si las piezas son muy grandes, quizás quieras subir el 50 a 80
		if global_position.distance_to(cell.global_position) < 60:
			if cell.index == target_index:
				global_position = cell.global_position
				is_locked = true
				z_index = 1 # Se queda un pelín por encima de la celda pero bajo el marco si quieres
				break
