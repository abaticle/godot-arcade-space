class_name EnemySpaceship extends Spaceship


@export_category("Enemy spaceship")
@export var detection_radius = 500
@export var attack_radius = 1000
@export var thrust_curve: Curve
@export var thrust_closest: int = 400
@export var thrust_farest: int = 800


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


func ai_update_thrust(delta: float) -> void:
	if abs(angle_to_target) > deg_to_rad(30):
		return
	
	var distance = (target.global_position - global_position).length()
	
	current_engine_power = max_engine_power
	
	if distance > 600:
		thrust = transform.x * current_engine_power
	else:
		thrust = transform.x * -current_engine_power
		
	Globals.display_value("enemy_thrust", thrust)
	Globals.display_value("enemy_distance", distance)
		
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
				ai_update_thrust(delta)
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
		
