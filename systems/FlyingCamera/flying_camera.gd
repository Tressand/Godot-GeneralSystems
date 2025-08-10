extends Camera3D

@export var base_speed : float = 5.0
@export var sprintMultiplier : float = 2
@export var mouseSensitivity : float = 0.1
@export var lock_mouse : bool
var speed : float
var velocity : Vector3
var cameraDrag : bool
var lastMousePos : Vector2

func get_input_axis(negative: Key, positive: Key) -> int:
	return 1 if Input.is_key_pressed(positive) else 0 - 1 if Input.is_key_pressed(negative) else 0

func _physics_process(delta: float) -> void:
	if !self.current : return
	speed = base_speed * (sprintMultiplier if Input.is_key_pressed(KEY_SHIFT) else 1.0)
	
	var input_dir : Vector3 = Vector3(
		get_input_axis(KEY_A, KEY_D),
		get_input_axis(KEY_CTRL, KEY_SPACE),
		get_input_axis(KEY_W, KEY_S)
	)
	var direction : Vector3 = (
		transform.basis.x * input_dir.x +
		transform.basis.y * input_dir.y +
		transform.basis.z * input_dir.z 
	).normalized()
	
	self.global_position += direction * speed * delta
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if cameraDrag :
			var mousevel : Vector2 = get_viewport().get_mouse_position() - lastMousePos
			self.rotation += Vector3(mousevel.y, mousevel.x, 0) * mouseSensitivity * 0.01
		else :
			cameraDrag = true
	else :
		cameraDrag = false
	lastMousePos = get_viewport().get_mouse_position()
