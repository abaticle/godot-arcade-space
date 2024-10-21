extends RigidBody2D

@export var _parent_planet: Planet

@onready var vfx_explosion: GPUParticles2D = $VFX/Explosion
@onready var parent_planet: Planet = get_parent()

var gravity_force = Vector2.ZERO
var future_positions: PackedVector2Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orbit(parent_planet)
	pass # Replace with function body.

func update_direction_line() -> void:
	$"Lines/FuturePositions".clear_points()
	for future_position in future_positions:
		$"Lines/FuturePositions".add_point(position - future_position)
	$"Lines/FuturePositions".global_rotation = deg_to_rad(180)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func orbit(planet: Planet) -> void:
	if not planet:
		return

	var v_orbit = sqrt((Globals.GRAVITY_CONSTANT * planet.mass) / global_position.distance_to(planet.global_position))
	
	# Applique une impulsion initiale pour simuler une orbite
	var direction = (global_transform.origin - planet.global_transform.origin).normalized().rotated(PI / 2)
	apply_central_impulse(direction * v_orbit)

func _physics_process(delta):
	update_gravity_force()
	constant_force = gravity_force
	#apply_central_impulse(constant_force * delta)  # Applique la force gravitationnelle
	update_direction_line()
	
	constant_torque = 100
	
	#future_positions = predict_future_positions(50, delta * 10)


func hit(body: Area2D) -> void:
	# Move asteroid
	var force = Vector2.RIGHT.rotated(body.global_rotation)
	apply_central_impulse(force * 50)
	
	# And display explosion
	vfx_explosion.emitting = true


func update_gravity_force() -> void:
	gravity_force = get_gravity_force(global_transform.origin)


func get_gravity_force(current_position: Vector2) -> Vector2:	
	var force = Vector2.ZERO
	
	var distance = parent_planet.global_transform.origin - current_position
	var distance_squared = distance.length_squared()
	
	if distance_squared > 0.1: 
		force += distance.normalized() * Globals.GRAVITY_CONSTANT * parent_planet.mass / distance_squared	

	return force
	
	
	
func is_position_inside_planet(current_position: Vector2) -> bool:
	if current_position.distance_to(parent_planet.global_transform.origin) < parent_planet.planet_size:
		return true
	return false


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
		var acceleration = total_force #total_force / spaceship_mass

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
