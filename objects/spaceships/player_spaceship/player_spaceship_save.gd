extends RigidBody2D


@export var engine_power = 800
@export var spin_power = 10000
@export var max_speed = 200
@export var spaceship_mass = 10
@export var background: ColorRect

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("planets")
@onready var thrust_sound: AudioStreamPlayer = $ThrustSound
@onready var thrust_particles: GPUParticles2D = $"VFX/ThrustParticles"
@onready var thrust_back_particles: GPUParticles2D = $"VFX/ThrustBackParticles"
@onready var strafe_left_particles: GPUParticles2D = $"VFX/StrafeLeftParticles"
@onready var strafe_right_particles: GPUParticles2D = $"VFX/StrafeRightParticles"

var thrust = Vector2.ZERO
var strafe = Vector2.ZERO
var rotation_dir = 0
var gravity_force = Vector2.ZERO

var update_future_positions = true
var future_positions: PackedVector2Array

func _ready() -> void:
	mass = spaceship_mass
	pass


func is_position_inside_planet(current_position: Vector2) -> bool:
	for planet in planets:
		if current_position.distance_to(planet.global_transform.origin) < planet.planet_size:
			return true
	return false
	
	
# update thrust and rotation_id
func get_input():
	thrust = Vector2.ZERO
	strafe = Vector2.ZERO
	
	var thrust_actions: Array[String] = [
		"thrust",
		"thrust_back",
		"strafe_left",
		"strafe_right"
	]

	thrust_particles.emitting = false	
	thrust_back_particles.emitting = false	
	strafe_left_particles.emitting = false	
	strafe_right_particles.emitting = false	
	
	for action in thrust_actions:
		if Input.is_action_just_released(action):
			thrust_sound.stop()		
		if Input.is_action_pressed(action) && !thrust_sound.playing:
			thrust_sound.play()
		
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
		thrust_particles.emitting = true
	
	if Input.is_action_pressed("thrust_back"):
		thrust = -transform.x * engine_power
		thrust_back_particles.emitting = true
	
	if Input.is_action_pressed("strafe_left"):
		strafe = -transform.y * engine_power * GlobalVariables.SPACESHIP_STRAFE_MODIFIER
		strafe_left_particles.emitting = true
	
	if Input.is_action_pressed("strafe_right"):
		strafe = transform.y * engine_power * GlobalVariables.SPACESHIP_STRAFE_MODIFIER
		strafe_right_particles.emitting = true
	
	var direction_to_mouse = get_global_mouse_position() - global_position
	var desired_angle = direction_to_mouse.angle()
	
	rotation = desired_angle


func update_gravity_force() -> void:
	gravity_force = get_gravity_force(global_transform.origin)
	


func get_gravity_force(current_position: Vector2) -> Vector2:	
	var force = Vector2.ZERO
	for planet in planets:
		var distance = planet.global_transform.origin - current_position
		var distance_squared = distance.length_squared()
		if distance_squared > 0.1: 
			force += distance.normalized() * GlobalVariables.GRAVITY_CONSTANT * planet.mass * spaceship_mass / distance_squared	
	
	return force

func update_direction_line() -> void:
	$GravityLine.clear_points()
	$DirectionLine.clear_points()
	$FuturePositions.clear_points()
	
	if GlobalVariables.SPACESHIP_DRAW_DIRECTION:
		$DirectionLine.add_point(Vector2.ZERO)
		$DirectionLine.add_point(linear_velocity)
		$DirectionLine.global_rotation = 0
	
	if GlobalVariables.SPACESHIP_DRAW_GRAVITY:
		$GravityLine.add_point(Vector2.ZERO)
		$GravityLine.add_point(gravity_force * 0.2)
		$GravityLine.global_rotation = 0
			
	for future_position in future_positions:
		$FuturePositions.add_point(position - future_position)
	$FuturePositions.global_rotation = deg_to_rad(180)


func predict_future_positions(steps: int, delta: float) -> PackedVector2Array:
	var positions: PackedVector2Array
	var future_velocity = linear_velocity
	var future_position = global_position
	var current_gravity_force = gravity_force
	
	positions.append(future_position)

	# Simule les mouvements futurs du vaisseau pour 'steps' pas de temps
	for i in range(steps):
		
		# Calculer la force totale (propulsion + gravité)
		#var total_force = current_thrust + current_gravity_force
		var total_force = current_gravity_force

		# Calculer l'accélération : F = ma => a = F/m
		var acceleration = total_force / spaceship_mass

		# Mettre à jour la vélocité : v = u + at
		future_velocity += acceleration * delta

		# Mettre à jour la position : s = s + vt
		future_position += future_velocity * delta
		
		if is_position_inside_planet(future_position):
			break
		
	
		
		# Ajouter la position future au tableau
		positions.append(future_position)

		## Optionnel : mettre à jour la force de gravité (si elle change avec la position)
		current_gravity_force = get_gravity_force(future_position)

	return positions

func update_background() -> void:
	var shader: ShaderMaterial = background.material
	
	shader.set_shader_parameter("speed_x", linear_velocity.x * 0.001)
	shader.set_shader_parameter("speed_y", linear_velocity.y * 0.001)
	pass

func _physics_process(delta):
	update_gravity_force()
	get_input()
	
	#constant_force = (thrust + calculate_gravity_force(delta)) * delta * 1000
	constant_force = thrust + strafe + gravity_force
	constant_torque = rotation_dir * spin_power
	
	update_direction_line()
	update_background()
	
	future_positions = predict_future_positions(GlobalVariables.SPACESHIP_MAXIMUM_FUTURE_POSITIONS, delta * GlobalVariables.SPACESHIP_FUTURE_POSITION_MUTIPLIER)

func _integrate_forces(state) -> void:
	#pass
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
		
func _process(_delta: float) -> void:
	pass
