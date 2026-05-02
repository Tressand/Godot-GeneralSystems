extends Sprite2D
class_name PixelImage

@export var size : Vector2i = Vector2i(256,256)
@export var bg_color : Color = Color.WHITE

@onready var image : Image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
var buffer : PackedColorArray

func _ready() -> void:
	buffer.resize(size.x * size.y)
	buffer.fill(bg_color)
	texture = ImageTexture.create_from_image(image)

	set_pixel(50, 50, Color.GREEN)
	set_pixel(256 - 50, 256 - 50, Color.GREEN)

func get_pixel(x:int,y:int) -> Color : return buffer[x*size.x + y]
func set_pixel(x:int,y:int,color:Color) -> void : buffer[x*size.x + y] = color

func p_draw_rect(top_anchor : Vector2i, bottom_anchor : Vector2i, color : Color) -> void:
	var rect_size : Vector2i = abs(bottom_anchor - top_anchor)
	for x : int in rect_size.x :
		for y : int in rect_size.y:
			set_pixel(top_anchor.x + x,top_anchor.y + y,color)

#func draw_triangle(a:Vector2i, b:Vector2i, c:Vector2i, color:Color) -> void:
	#return

func _process(_delta : float) -> void:
	for i : int in range(size.y):
		for j : int in range(size.x):
			image.set_pixel(i,j, get_pixel(i,j))
	texture.update(image)
