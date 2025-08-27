extends Sprite2D
class_name ImageRenderer

@export var size : Vector2i = Vector2i(0,0)
var pixels : PixelImage

class PixelImage :
	var texture : ImageTexture
	var image : Image
	var buffer : PackedColorArray
	var width : int
	var height : int
	
	static func create(size : Vector2i, background_color: Color) -> PixelImage:
		var new_image : PixelImage = PixelImage.new()
		new_image.image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
		new_image.width = size.x
		new_image.height = size.y
		new_image.buffer.resize(size.x * size.y)
		new_image.buffer.fill(background_color)
		new_image.texture = ImageTexture.create_from_image(new_image.image)
		return new_image
	
	func get_pixel(x:int,y:int) -> Color : return buffer[x*width + y]
	func set_pixel(x:int,y:int,color:Color) -> void : buffer[x*width + y] = color
	
	func draw_rect(top_anchor : Vector2i, bottom_anchor : Vector2i, color : Color) -> void:
		var rect_size : Vector2i = abs(bottom_anchor - top_anchor)
		for x : int in rect_size.x :
			for y : int in rect_size.y:
				set_pixel(top_anchor.x + x,top_anchor.y + y,color)
	
	func draw_triangle(a:Vector2i, b:Vector2i, c:Vector2i, color:Color) -> void:
		return
	
	func update() -> void:
		for i : int in range(height):
			for j : int in range(width):
				image.set_pixel(i,j, get_pixel(i,j))
		texture.update(image)

func _ready() -> void:
	pixels = PixelImage.create(size, Color.WHITE)
	texture = pixels.texture
	
	pixels.set_pixel(50, 50, Color.GREEN)
	pixels.set_pixel(256 - 50, 256 - 50, Color.GREEN)
	pixels.draw_line(Vector2i(50, 50), Vector2i(256 - 50, 256 - 50), Color.RED)

func _process(_delta: float) -> void:
	pixels.update()
