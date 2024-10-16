#extends "res://objects/spaceships/_base/spaceship.gd"
class_name EnemySpaceship extends Spaceship

@export var max_health: int = 50
@export var attack_radius = 300
@export var detection_radius = 500

var health: int 
var target

var direction_to_target = Vector2.ZERO

var state: State = State.IDLE

enum State { IDLE, SEEK, ATTACK }

func get_closest_player() -> PlayerSpaceship:
	var players = get_tree().get_nodes_in_group("player")
	var closest: PlayerSpaceship
	var min_distance: float = 0
	
	for player in players:
		if player.global_position.distance_to(global_position) < min_distance || min_distance == 0:
			closest = player
	
	return closest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	target = get_closest_player()
	
	if target:
		state = State.SEEK

func ai_input() -> void:
	match state:
		State.IDLE:
			thrust = Vector2.ZERO
			rotation_dir = 0
			pass
			
		State.SEEK:
			if target:
				direction_to_target = (target.global_position - global_position).normalized()
				thrust = direction_to_target * engine_power
				rotation_dir = sign(direction_to_target.angle_to_point(global_position))
				
				if global_position.distance_to(target.global_position) < attack_radius:
					state = State.ATTACK
			else:
				state = State.IDLE
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	update_gravity_force()
	
	#constant_force = (thrust + calculate_gravity_force(delta)) * delta * 1000
	constant_force = thrust + strafe + gravity_force
	constant_torque = rotation_dir * spin_power

func hit(bullet):
	var knockback = position + (Vector2.ONE * 0.01)
	
	apply_impulse(knockback, Vector2.ZERO)
	
	health -= bullet.damages
	
	if health <= 0:
		queue_free()
		
