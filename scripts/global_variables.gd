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
