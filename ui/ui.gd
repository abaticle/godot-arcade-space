extends PanelContainer

#@onready var camera = $"../../Camera2D"
#@onready var spaceship = $"../../Spaceship"
#@onready var game: Node2D = $"../../"

@export var camera: Camera2D
@export var spaceship: RigidBody2D
@export var game: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func vector2_to_string(vector: Vector2, snap: float) -> String:
	return str(snapped(vector.x, snap)) + ";" + str(snapped(vector.y, snap))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var spaceship_speed = snapped(spaceship.linear_velocity.length(), 1)
	var spaceship_direction = snapped(rad_to_deg(spaceship.rotation), 1)
	var fps = snapped(Engine.get_frames_per_second(),0.01)
	var zoom = camera.zoom
	
	$"Container/SpeedLabel".text = "Speed: " + str(spaceship_speed)
	$"Container/FPSLabel".text = "FPS: " + str(fps)
	$"Container/DirectionLabel".text = "Direction: " + str(spaceship_direction) + "°"
	$"Container/Zoom".text = "Zoom: " + str(zoom)
	$"Container/MousePosition".text = "Mouse: " + vector2_to_string(game.get_local_mouse_position(), 1)
