class_name DebugVector extends Node2D

@export var activate: bool = true

# Update a named vector
func update(name: String, new_vector: Vector2):
	
	if !activate: return
	
	var line: Line2D = find_child(name, false, false)
	
	if line == null:
		printerr(name + " not found !")
	
	line.clear_points()
	line.add_point(Vector2.ZERO)
	var vector = new_vector
	
	# Set minimum vector size
	if vector.length() < 30:
		vector  = vector.normalized() * 30
		
	line.add_point(vector)
	line.global_rotation = 0

# Create a new vector to debug, with a name and a color
func add(name: String, color: Color, vector: Vector2) -> void:
	
	if !activate: return
	
	var line = Line2D.new()
	line.owner = self
	line.name = name
	line.width = 1
	line.default_color = color
	add_child(line)

func _process(delta: float) -> void:
	global_rotation = 0
