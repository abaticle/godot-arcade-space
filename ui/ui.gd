extends PanelContainer

#@onready var camera = $"../../Camera2D"
#@onready var spaceship = $"../../Spaceship"
#@onready var game: Node2D = $"../../"

@export var camera: Camera2D
@export var player_spaceship: PlayerSpaceship
@export var game: Node2D
@export var enemy_spaceship: EnemySpaceship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func vector2_to_string(vector: Vector2, snap: float) -> String:
	return str(snapped(vector.x, snap)) + ";" + str(snapped(vector.y, snap))

func enum_to_string(enum_definition, value: int) -> String:
	return enum_definition.keys()[value]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_spaceship_speed = snapped(player_spaceship.linear_velocity.length(), 1)
	var player_spaceship_direction = snapped(rad_to_deg(player_spaceship.rotation), 1)
	var fps = snapped(Engine.get_frames_per_second(),0.01)
	var zoom = camera.zoom
	
	$Container/SpeedLabel.text = "Speed: " + str(player_spaceship_speed)
	$Container/FPSLabel.text = "FPS: " + str(fps)
	$Container/DirectionLabel.text = "Direction: " + str(player_spaceship_direction) + "°"
	$Container/Zoom.text = "Zoom: " + str(zoom)
	$Container/MousePosition.text = "Mouse: " + vector2_to_string(game.get_local_mouse_position(), 1)
	if enemy_spaceship != null:
		$Container/EnemyState.text = "EnemyState: " + enum_to_string(enemy_spaceship.State, enemy_spaceship.state)
	else:
		$Container/EnemyState.text = "EnemyState:dead"
