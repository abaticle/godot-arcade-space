extends GPUParticles2D

@export var color: Color

func _on_ready() -> void:
	pass
	

func _on_finished() -> void:
	queue_free()
