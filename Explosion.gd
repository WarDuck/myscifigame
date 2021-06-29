extends Particles2D

var life = 20

func _physics_process(delta):
	life -= delta
	if life <= 0:
		queue_free()
