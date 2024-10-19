extends Area2D

var speed = 200
var damages = 30
var life_time_max = 200
var life_time = 0

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
