class_name Spaceship extends RigidBody2D

@export var engine_power = 800
@export var spin_power = 10000
@export var max_speed = 200
@export var spaceship_mass = 10

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("planets")

var thrust = Vector2.ZERO
var strafe = Vector2.ZERO
var rotation_dir = 0
var gravity_force = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta):
	update_gravity_force()
	
	constant_force = thrust + strafe + gravity_force
	constant_torque = rotation_dir * spin_power


func _ready() -> void:
	mass = spaceship_mass
	pass


func get_gravity_force(current_position: Vector2) -> Vector2:	
	var force = Vector2.ZERO
	for planet in planets:
		var distance = planet.global_transform.origin - current_position
		var distance_squared = distance.length_squared()
		if distance_squared > 0.1: 
			force += distance.normalized() * GlobalVariables.GRAVITY_CONSTANT * planet.mass * spaceship_mass / distance_squared	
	
	return force


func is_position_inside_planet(current_position: Vector2) -> bool:
	for planet in planets:
		if current_position.distance_to(planet.global_transform.origin) < planet.planet_size:
			return true
	return false

func update_gravity_force() -> void:
	gravity_force = get_gravity_force(global_transform.origin)
