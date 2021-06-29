extends Area2D

const speed = 500
const rotationSpeed = 2
const damage = 10
export (PackedScene) var Explosion

func _physics_process(delta):
	position += transform.x * speed * delta
	var mousePos = get_local_mouse_position()
	if abs(mousePos.y) > 30 && mousePos.x > 10:
		rotation += sign(mousePos.y) * rotationSpeed * delta
	
func _on_Missile_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	var explosion = Explosion.instance()
	explosion.emitting = true
	get_parent().add_child(explosion)
	explosion.transform = global_transform
	queue_free()
