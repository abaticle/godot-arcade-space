class_name ZoomingCamera2D
extends Camera2D

@export var current_zoom = 1
@export var zoom_duration := 0.2
@export var availables_zooms = [0.6, 1, 1.5]

@onready var spaceship = $"../Spaceship"
@onready var background:ColorRect = $"../CanvasLayer/Background"

func create_zoom_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = Vector2(current_zoom, current_zoom)
	
func update_zoom(increase: bool) -> void:
	var index = availables_zooms.find(current_zoom)
	
	if increase:
		index += 1
	else: 
		index -= 1

	if index >= 0 && index < availables_zooms.size():
		current_zoom = availables_zooms[index]
		create_zoom_tween().tween_property(self, "zoom", Vector2(current_zoom, current_zoom), zoom_duration)

	if GlobalVariables.DEBUG_CAMERA_ZOOM:	
		print("New zoom %f" % current_zoom)
		
func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		update_zoom(true)
	if event.is_action_pressed("zoom_out"):
		update_zoom(false)

func _process(_delta: float) -> void:
	position = get_global_mouse_position() #spaceship.position
	var camera_position = spaceship.position + (get_global_mouse_position() - spaceship.position) * 0.4
	position = camera_position
	pass
