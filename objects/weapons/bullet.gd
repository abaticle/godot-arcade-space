extends Area2D

var speed = 750
var damages = 30


func _physics_process(delta):
	position += transform.x * speed * delta	
	
func _on_Bullet_body_entered(body: Node):
	pass
