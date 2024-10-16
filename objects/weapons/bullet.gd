extends Area2D

var speed = 300
var damages = 30
var life_time = 2
var life = 0

func _physics_process(delta):
	life += delta
	
	if life > life_time:
		queue_free()
	
	position += transform.x * speed * delta	
	
func _on_Bullet_body_entered(body: Node):
	if body.is_in_group("bullets"):
		pass
		
	if body.is_in_group("enemies"):
		body.hit(self)
		queue_free()
	
	if body.is_in_group("planets"):
		queue_free()
