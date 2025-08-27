extends Node3D

@export var nav_agent : NavigationAgent3D
@export var movement_component_3d : Node

func _process(_delta : float) -> void:
	if nav_agent.is_navigation_finished(): return
	movement_component_3d.set_target(nav_agent.get_next_path_position())

func navigate_to(new_position : Vector3) -> void:
	nav_agent.target_position = new_position
	var first_pos : Vector3 = nav_agent.get_next_path_position()
	movement_component_3d.set_target(first_pos)
