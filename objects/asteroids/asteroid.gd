extends RigidBody2D

@export var parent:

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func orbit(planet: Planet) -> void:
	var v: Vector2
	
	#v = sqrt((GlobalVariables.GRAVITY_CONSTANT * planet.mass) / global_position.distance_to(planet.global_position))
		
	
