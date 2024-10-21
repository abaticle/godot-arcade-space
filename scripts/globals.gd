extends Node

@export_group("Gravity")
@export var GRAVITY_CONSTANT: float = 10

@export_group("Spaceships")
@export var SPACESHIP_DRAW_GRAVITY = false
@export var SPACESHIP_MAXIMUM_FUTURE_POSITIONS = 800
@export var SPACESHIP_FUTURE_POSITION_MUTIPLIER = 15
@export var SPACESHIP_DRAW_DIRECTION = false
@export var SPACESHIP_MASS_MULTIPLIER = 1
@export var SPACESHIP_STRAFE_MODIFIER = 0.6

@export_group("Planets")
@export var PLANET_MASS_MULTIPLIER = 1

@export_group("Camera")
@export var DEBUG_CAMERA_ZOOM = false


var display_value_check = false

func display_value(name: String, value: Variant) -> void:
	var debug_variable = get_tree().get_root().find_child("DebugVariables", true, false)
	
	if debug_variable == null && !display_value_check:
		print("DebugVariable not set in current scene !")
		display_value_check = true
		return
		
		
	debug_variable.update(name, value)
