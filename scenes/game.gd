extends Node2D

@onready var planets: Array[Node] = get_tree().get_nodes_in_group("planets")
@onready var spaceships: Array[Node] = get_tree().get_nodes_in_group("spaceships")

var cursor = load("res://resources/target_cursor.png")

func _ready() -> void:

	Input.set_custom_mouse_cursor(cursor)
	#$Planet3.set_seed(randi_range(1, 10))
	#$Planet3.randomize_colors()
	#$Planet1.set_seed(randi_range(1, 10))
	#$Planet2.randomize_colors()
