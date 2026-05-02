extends Node

@export var character : CharacterBody3D

@export var speed : float = 5.0
@export var jump_height : float = 2.0
@export var jump_time : float = 0.3
@export var fall_time : float = 0.3

@onready var fall_gravity : Vector3 = Vector3.DOWN * (2 * jump_height / pow(fall_time,2))
@onready var jump_gravity : Vector3 = Vector3.DOWN * (2 * jump_height / pow(jump_time,2))
@onready var jump_velocity : float = sqrt(2*-jump_gravity.y*jump_height)

var movement_started : bool
var direction : Vector3

@export var target_threshhold : float = 0.1
@export var vertical_displacement : float = 0.5
var has_target : bool
var target : Vector3
signal target_reached
signal movement_start
signal movement_end
signal jump_start
signal jump_end

func set_target(position : Vector3) -> void:
	target = position
	has_target = true

func jump() -> void:
	character.velocity.y += jump_velocity
	jump_start.emit()

func _physics_process(delta: float) -> void:
	if !character.is_on_floor():
		character.velocity += (jump_gravity if character.velocity.y > 0 else fall_gravity) * delta
	
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
	if has_target && (character.global_position + (Vector3.UP * vertical_displacement)).distance_to(target) <= target_threshhold:
		target_reached.emit()
		direction = Vector3.ZERO
		has_target = false
	if movement_started && direction == Vector3.ZERO:
		movement_started = false
		movement_end.emit()
