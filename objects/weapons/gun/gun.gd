class_name Gun
 
@export var bullet_speed = 200
@export var bullet_damages = 30
@export var life_time_max = 200
@export var life_time = 0
@export var delay_per_shot: float = 0.5

var last_shot = 0


func shoot(): 
	if life_time < delay_per_shot: 
		return
	
	last_shot = 0
	
	var new_bullet = $Bullet.instantiate()
	
	owner.add_child(new_bullet)
	
	new_bullet.transform = $Muzzle.global_transform
	var spread = 5
	var random_angle = randf_range(spread * -1, spread)
	new_bullet.transform.x = new_bullet.transform.x.rotated(deg_to_rad(random_angle))



func _physics_process(delta):
	life_time += delta
	
	if life_time > life_time_max:
		queue_free()
		
	position += transform.x * speed * delta	



func _on_Bullet_body_entered(body: Node):
	if body.is_in_group("bullets"):
		pass
		
	if body.is_in_group("asteroids"):
		body.hit(self)
		queue_free()
		
	if body.is_in_group("enemies"):
		body.hit(self)
		queue_free()
	
	if body.is_in_group("planets"):
		body.hit(self)
		queue_free()


func _on_bullet_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
