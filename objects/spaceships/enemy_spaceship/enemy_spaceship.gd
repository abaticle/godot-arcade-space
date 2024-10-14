extends "res://objects/spaceships/_base/spaceship.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func ai_input() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	update_gravity_force()
	
	#constant_force = (thrust + calculate_gravity_force(delta)) * delta * 1000
	constant_force = thrust + strafe + gravity_force
	constant_torque = rotation_dir * spin_power
