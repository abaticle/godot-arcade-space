class_name Planet extends StaticBody2D
 
var time = 1000.0
var override_time = false
var original_colors

@export var planet_size: float = 50
@export var mass: int = 1000
#@export var relative_scale : float = 1.0
#@export var gui_zoom : float = 1.0

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var land:ColorRect = $Land

@onready var explosion = preload("res://objects/effects/explosion/explosion.tscn")


func _ready():
	mass *= Globals.PLANET_MASS_MULTIPLIER
	set_collision()
	original_colors = get_colors()
	
	# Multiply by 2 because using a radius
	$Land.size = Vector2(planet_size*2, planet_size*2) 
	$Land.position = collision_shape.position - Vector2(planet_size, planet_size) 
	
	# Set VFX colors
	#$Land.material.g

func set_collision() -> void:	
	collision_shape.shape.radius = planet_size
	#collision_shape.position += Vector2(planet_size, planet_size)
	#collision_shape.position.x = land.position.x + planet_size
	#collision_shape.position.y = land.position.y + planet_size

func set_pixels(_amount):
	pass
func set_light(_pos):
	pass
func set_seed(_sd):
	pass
func set_rotates(_r):
	pass
func update_time(_t):
	pass
func set_custom_time(_t):
	pass

func get_multiplier(mat):
	return (round(mat.get_shader_parameter("size")) * 2.0) / mat.get_shader_parameter("time_speed")
	
func _process(delta):
	time += delta	
	if !override_time:
		update_time(time)

func set_dither(_d):
	pass

func get_dither():
	pass

func get_colors():
	pass

func get_colors_from_shader(mat, uniform_name = "colors"):
	return mat.get_shader_parameter(uniform_name)

func hit(body: Area2D) -> void: 
	var new_explosion: GPUParticles2D = explosion.instantiate()
	
	add_child(new_explosion)
	new_explosion.one_shot = true
	new_explosion.emitting = true
	new_explosion.global_position = body.position
	new_explosion.rotation = 180 + get_angle_to(body.position)
	new_explosion.process_material.color = $Land.material.get_shader_parameter("colors")[0]
	
	pass


func set_colors_on_shader(mat, colors, uniform_name = "colors"):
	pass

func randomize_colors():
	pass

# Using ideas from https://www.iquilezles.org/www/articles/palettes/palettes.htm
func _generate_new_colorscheme(n_colors, hue_diff = 0.9, saturation = 0.5):
#	var a = Vector3(rand_range(0.0, 0.5), rand_range(0.0, 0.5), rand_range(0.0, 0.5))
	var a = Vector3(0.5,0.5,0.5)
#	var b = Vector3(rand_range(0.1, 0.6), rand_range(0.1, 0.6), rand_range(0.1, 0.6))
	var b = Vector3(0.5,0.5,0.5) * saturation
	var c = Vector3(randf_range(0.5, 1.5), randf_range(0.5, 1.5), randf_range(0.5, 1.5)) * hue_diff
	var d = Vector3(randf_range(0.0, 1.0), randf_range(0.0, 1.0), randf_range(0.0, 1.0)) * randf_range(1.0, 3.0)

	var cols = PackedColorArray()
	var n = float(n_colors - 1.0)
	n = max(1, n)
	for i in range(0, n_colors, 1):
		var vec3 = Vector3()
		vec3.x = (a.x + b.x *cos(6.28318 * (c.x*float(i/n) + d.x)))
		vec3.y = (a.y + b.y *cos(6.28318 * (c.y*float(i/n) + d.y)))
		vec3.z = (a.z + b.z *cos(6.28318 * (c.z*float(i/n) + d.z)))

		cols.append(Color(vec3.x, vec3.y, vec3.z))
	
	return cols

func get_layers():
	var layers = []
	for c in get_children():
		layers.append({"name": c.get_name(), "visible": c.visible})
	return layers

func toggle_layer(num):
	get_children()[num].visible = !get_children()[num].visible
