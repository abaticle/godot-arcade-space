class_name Spaceship extends RigidBody2D


@export var max_health: int = 50
@export var max_engine_power: int = 800
@export var spin_power = 10000
@export var max_speed = 200
@export var spaceship_mass = 10

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("planets")
@onready var thrust_particles: GPUParticles2D = $VFX/ThrustParticles
@onready var thrust_back_particles: GPUParticles2D = $VFX/ThrustBackParticles
@onready var strafe_left_particles: GPUParticles2D = $VFX/StrafeLeftParticles
@onready var strafe_right_particles: GPUParticles2D = $VFX/StrafeRightParticles

var current_engine_power: int = 0
var thrust = Vector2.ZERO
var strafe = Vector2.ZERO
var rotation_dir = 0
var gravity_force = Vector2.ZERO



func _ready() -> void:
	mass = spaceship_mass
	pass


func get_gravity_force(current_position: Vector2) -> Vector2:	
	var force = Vector2.ZERO
	for planet in planets:
		var distance = planet.global_transform.origin - current_position
		var distance_squared = distance.length_squared()
		if distance_squared > 0.1: 
			force += distance.normalized() * Globals.GRAVITY_CONSTANT * planet.mass * spaceship_mass / distance_squared	
	
	return force


func is_position_inside_planet(current_position: Vector2) -> bool:
	for planet in planets:
		if current_position.distance_to(planet.global_transform.origin) < planet.planet_size:
			return true
	return false

func update_gravity_force() -> void:
	gravity_force = get_gravity_force(global_transform.origin)


func play_vfx() -> void:
	
	thrust_particles.emitting = false	
	thrust_back_particles.emitting = false	
	strafe_left_particles.emitting = false	
	strafe_right_particles.emitting = false	
		
	if thrust.x > 0:
		thrust_particles.emitting = true
	if thrust.x < 0:
		thrust_back_particles.emitting = true
	if strafe.y > 0:
		strafe_left_particles.emitting = true
	if strafe.y < 0:
		strafe_right_particles.emitting = true
	
	
