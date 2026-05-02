extends Node

@export var movement_component : Node

@export_category("Menuing")
@export var pause : String = "pause"

@export_category("Action Map")
@export var up : String = "up"
@export var down : String = "down"
@export var left : String = "left"
@export var right : String = "right"
@export var jump : String = "jump"

@export_category("Camera")
@export var camera : Camera3D
@export var camera_pivot : Node3D
@export var mouse_control_camera : bool = true
@export var sensitivity : float = 1

func _ready() -> void:
	if mouse_control_camera :
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") :
		Input.mouse_mode = (
			Input.MOUSE_MODE_CAPTURED 
			if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED 
			else Input.MOUSE_MODE_VISIBLE
		)
		mouse_control_camera = !mouse_control_camera

func _process(delta: float) -> void:
	var movement_direction : Vector3 = (
		( camera.global_basis.x * Input.get_axis(left,right)
		  + camera.global_basis.z * Input.get_axis(up,down)
		) * Vector3(1,0,1)
	).normalized()
	movement_component.direction = movement_direction
	if Input.is_action_just_pressed(jump) :
		movement_component.jump()
	if mouse_control_camera :
		var mouse_velocity : Vector2 = Input.get_last_mouse_screen_velocity()
		var cam_speed : float = sensitivity * 0.01 * delta
		camera_pivot.rotate_y(-mouse_velocity.x * cam_speed)
		camera_pivot.rotate(camera_pivot.basis.x, mouse_velocity.y * cam_speed)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x,deg_to_rad(-60),deg_to_rad(60),)
