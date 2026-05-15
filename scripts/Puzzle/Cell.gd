extends Area2D

var index = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func setup_cell(p_index, p_size):
	index = p_index
	if collision.shape:
		collision.shape.size = p_size
	sprite.region_enabled = false
	sprite.scale = p_size / sprite.texture.get_size()
	sprite.modulate = Color(1, 1, 1, 0.1)

func _on_mouse_entered() -> void:
	sprite.modulate = Color(0.4, 0.4, 0.4, 0.3)

func _on_mouse_exited() -> void:
	sprite.modulate = Color(1, 1, 1, 0.1)
