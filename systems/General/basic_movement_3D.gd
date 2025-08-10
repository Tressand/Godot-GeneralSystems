extends Node

@export var character : CharacterBody3D

@export var speed : float = 5.0
@export var jump_velocity : float = 4.5
@export var gravity : Vector3 = Vector3.DOWN * 9.8

@export var target_threshhold : float = 0.1
@export var vertical_displacement : float = 0.5
var has_target : bool
var target : Vector3

var movement_started : bool = false
signal movement_start
signal movement_end
signal target_reached

var direction : Vector3

func set_target(position : Vector3) -> void:
	target = position
	has_target = true

func _physics_process(delta: float) -> void:
	if !character.is_on_floor():
		character.velocity += gravity * delta
	
	if has_target:
		direction = (target - character.global_position).normalized()
	
	if direction:
		if !movement_started:
			movement_started = true
			movement_start.emit()
		direction.y = 0
		character.velocity.x = direction.x * speed
		character.velocity.z = direction.z * speed
		
	else:
		character.velocity = Vector3(0,character.velocity.y,0)
	
	character.move_and_slide()
	#print(character.global_position.distance_to(target))
	if has_target && (character.global_position + (Vector3.UP * vertical_displacement)).distance_to(target) <= target_threshhold:
		target_reached.emit()
		direction = Vector3.ZERO
		has_target = false
	if movement_started && direction == Vector3.ZERO:
		movement_started = false
		movement_end.emit()
