class_name EnemySpaceship extends Spaceship

@export var max_health: int = 50
@export var attack_radius = 1000
@export var detection_radius = 500

enum State { IDLE, SEEK, ATTACK }

var health: int
var target: PlayerSpaceship
var direction_to_target = Vector2.ZERO
var state = State.IDLE
var ai_shoot = false
var angle_to_target: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):	
	update_gravity_force()
	ai_input(delta)
	
	super.play_vfx()
	
	#constant_force = (thrust + calculate_gravity_force(delta)) * delta * 1000
	#constant_force = thrust + gravity_force
	constant_torque = rotation_dir * spin_power
	constant_force = thrust + gravity_force
	
	global_rotation

	$DebugVector.update("direction",Vector2.from_angle(global_rotation))
	$DebugVector.update("target",direction_to_target * 30)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DebugVector.add("target", Color.YELLOW, Vector2.ZERO)
	$DebugVector.add("direction", Color.SKY_BLUE, Vector2.ZERO)
	
	
	health = max_health
	target = get_target()
	
	angular_damp = 5
	
	if target:
		state = State.SEEK

func ai_update_rotation_dir() -> void:
	# Update target rotation
	angle_to_target = angle_difference(global_rotation, direction_to_target.angle())
	
	if abs(angle_to_target) > deg_to_rad(5):
		rotation_dir = clamp(angle_to_target, -1, 1)
	else:
		rotation_dir = 0


func ai_update_thrust() -> void:
	#TODO: Gérer IA thrust
	
	if abs(angle_to_target) > deg_to_rad(30):
		return
	
	var distance = (target.global_position - global_position).length()
	
	#Globals.display_value("transform_x", transform.x)
	#Globals.display_value("distance", distance)
	
	if distance > 400:
		thrust = transform.x * engine_power
	else:
		thrust = transform.x * engine_power * -1
		#thrust = Vector2.ZERO
	direction_to_target = (target.global_position - global_position).normalized()


func ai_input(delta: float) -> void:
	
	match state:
		State.IDLE:
			thrust = Vector2.ZERO
			rotation_dir = 0
			pass
					
		State.SEEK:
			if target:
				ai_update_rotation_dir()
				ai_update_thrust()
				Globals.display_value("angle_to_target", rad_to_deg(angle_to_target))
			else:
				state = State.IDLE


func get_target() -> PlayerSpaceship:
	var players = get_tree().get_nodes_in_group("player")
	var closest: PlayerSpaceship
	var min_distance: float = 0
	
	for player in players:
		if player.global_position.distance_to(global_position) < min_distance || min_distance == 0:
			closest = player
	
	return closest


func hit(bullet: Area2D):
	var force = Vector2.RIGHT.rotated(bullet.global_rotation)
	apply_central_impulse(force * 50)
	
	health -= bullet.damages
	
	if health <= 0:
		queue_free()
		
