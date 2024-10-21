class_name PlayerSpaceship extends Spaceship

@export var background: ColorRect 
@export var current_weapon: WeaponResource

@onready var thrust_sound: AudioStreamPlayer = $ThrustSound
@onready var bullet = preload("res://objects/weapons/bullet.tscn")

var update_future_positions = true
var future_positions: PackedVector2Array
var lastShot:float = 0

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

	#thrust_particles.emitting = false	
	#thrust_back_particles.emitting = false	
	#strafe_left_particles.emitting = false	
	#strafe_right_particles.emitting = false	
	
	for action in thrust_actions:
		if Input.is_action_just_released(action):
			thrust_sound.stop()		
		if Input.is_action_pressed(action) && !thrust_sound.playing:
			thrust_sound.play()
		
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
		#thrust_particles.emitting = true
	
	if Input.is_action_pressed("thrust_back"):
		thrust = -transform.x * engine_power
		#thrust_back_particles.emitting = true
	
	if Input.is_action_pressed("strafe_left"):
		strafe = -transform.y * engine_power * Globals.SPACESHIP_STRAFE_MODIFIER
		#strafe_left_particles.emitting = true
	
	if Input.is_action_pressed("strafe_right"):
		strafe = transform.y * engine_power * Globals.SPACESHIP_STRAFE_MODIFIER
		#strafe_right_particles.emitting = true
	
	if Input.is_action_pressed("shoot_primary") && lastShot > 0.1:
		shoot()
	
	var direction_to_mouse = get_global_mouse_position() - global_position
	var desired_angle = direction_to_mouse.angle()
	
	rotation = desired_angle

	

func shoot() -> void:
	lastShot = 0
	
	var new_bullet = bullet.instantiate()
	
	owner.add_child(new_bullet)
	
	new_bullet.transform = $Muzzle.global_transform
	var spread = 5
	var random_angle = randf_range(spread * -1, spread)
	new_bullet.transform.x = new_bullet.transform.x.rotated(deg_to_rad(random_angle))
	
	#$BulletSound.play()

func update_direction_line() -> void:
	$"Lines/FuturePositions".clear_points()
	for future_position in future_positions:
		$"Lines/FuturePositions".add_point(position - future_position)
	$"Lines/FuturePositions".global_rotation = deg_to_rad(180)


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
	
	super.play_vfx()
	
	#constant_force = (thrust + calculate_gravity_force(delta)) * delta * 1000
	constant_force = thrust + strafe + gravity_force
	constant_torque = rotation_dir * spin_power
	
	update_direction_line()
	update_background()
	
	future_positions = predict_future_positions(Globals.SPACESHIP_MAXIMUM_FUTURE_POSITIONS, delta * Globals.SPACESHIP_FUTURE_POSITION_MUTIPLIER)
	
	lastShot += delta

func _integrate_forces(state) -> void:
	#pass
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
		
func _process(_delta: float) -> void:
	pass
