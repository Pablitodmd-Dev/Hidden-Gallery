extends Node

var cells = []
var pieces = []
const images = [
	"res://assets/Paintings/Animal1.png",
	"res://assets/Paintings/Animal2.png",
	"res://assets/Paintings/Animal3.png"
]

var columns = 4
var rows = 2
var target_width = 800.0

var is_any_piece_dragging = false

func get_image():
	var image = Image.load_from_file(images.pick_random())
	return ImageTexture.create_from_image(image)
