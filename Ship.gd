extends KinematicBody2D


export (int) var speed = 50
export (float) var rotation_speed = 0.5

export (PackedScene) var Missile

var velocity = Vector2()
var rotation_dir = 0
const max_rotation = 3
const min_rotation = -3
var burn = 0
const max_burn = 3
const min_burn = -1
const max_health = 100
var health = 100
const reload_timer = 5
var front_reload = 0
var starboard_reload = 0
var port_reload = 0

func get_input():
	if Input.is_action_just_pressed("right"):
		rotation_dir += 1
		if rotation_dir > max_rotation:
			rotation_dir = max_rotation
	if Input.is_action_just_pressed("left"):
		rotation_dir -= 1
		if rotation_dir < min_rotation:
			rotation_dir = min_rotation
	if Input.is_action_just_pressed("down"):
		burn -= 1
		if burn < min_burn:
			burn = min_burn
	if Input.is_action_just_pressed("up"):
		burn += 1
		if burn > max_burn:
			burn = max_burn
	if Input.is_action_just_pressed("shoot"):
		shoot()		

func _physics_process(delta):
	get_input()
	$Particles2D.get_process_material().initial_velocity = speed * burn
	velocity = Vector2(speed * burn, 0).rotated(rotation)
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
	if front_reload > 0:
		front_reload -= delta
	if starboard_reload > 0:
		starboard_reload -= delta	
	if port_reload > 0:
		port_reload -= delta
		
func shoot():
	var mousePos = get_local_mouse_position()
	if mousePos.x > 100 && mousePos.x > abs(mousePos.y) && front_reload <= 0:
		front_reload = reload_timer
		var frontMissile = Missile.instance()
		get_tree().get_current_scene().add_child(frontMissile)
		frontMissile.transform = $FrontLauncher.global_transform
	
	if mousePos.y > 30 && abs(mousePos.y) > abs(mousePos.x)  && starboard_reload <= 0:
		starboard_reload = reload_timer
		var starboardMissile1 = Missile.instance()
		get_tree().get_current_scene().add_child(starboardMissile1)
		starboardMissile1.transform = $StarboardLauncher1.global_transform
	
		var starboardMissile2 = Missile.instance()
		get_tree().get_current_scene().add_child(starboardMissile2)
		starboardMissile2.transform = $StarboardLauncher2.global_transform
		
		var starboardMissile3 = Missile.instance()
		get_tree().get_current_scene().add_child(starboardMissile3)
		starboardMissile3.transform = $StarboardLauncher3.global_transform
	
	if mousePos.y < -30 && abs(mousePos.y) > abs(mousePos.x) && port_reload <= 0:
		port_reload = reload_timer
		var portMissile1 = Missile.instance()
		get_tree().get_current_scene().add_child(portMissile1)
		portMissile1.transform = $PortLauncher1.global_transform
		
		var portMissile2 = Missile.instance()
		get_tree().get_current_scene().add_child(portMissile2)
		portMissile2.transform = $PortLauncher2.global_transform
		
		var portMissile3 = Missile.instance()
		get_tree().get_current_scene().add_child(portMissile3)
		portMissile3.transform = $PortLauncher3.global_transform
	
func takeDamage(damage):
	health -= damage
	$HealthDisplay.update_healthbar(health)
	if health <= 0:
		queue_free()
		get_tree().change_scene("res://Menu.tscn")
