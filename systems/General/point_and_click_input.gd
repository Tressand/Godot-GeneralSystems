extends Node3D

@export var movement_component : Node
@export var camera : Camera3D
@export var nav_agent : NavigationAgent3D
@export var ray_length : float = 1000

var click : bool

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !click:
			var mouse_pos : Vector2 = get_viewport().get_mouse_position()
			var ray_query : PhysicsRayQueryParameters3D
			ray_query.from = camera.project_ray_origin(mouse_pos)
			ray_query.to = ray_query.from * ray_length
			get_world_3d()
		click = true
