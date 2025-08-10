extends Node

@export var movement_component : Node
@export var tree : AnimationTree
@export var root : Node3D

@export var turn_speed : float = 20


func _ready() -> void:
	movement_component.movement_start.connect(run)
	movement_component.movement_end.connect(idle)

func _process(delta: float) -> void:
	if movement_component.direction:
		root.look_at(
			root.global_position -
			(root.transform.basis.z).slerp(movement_component.direction, delta * turn_speed)
		)

func idle() -> void:
	tree.set("parameters/conditions/idle", true)
	tree.set("parameters/conditions/run", false)

func run() -> void:
	tree.set("parameters/conditions/run", true)
	tree.set("parameters/conditions/idle", false)
