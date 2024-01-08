extends CharacterBody2D

class_name Player

signal healthChanged
signal expChanged
signal levelUp

@export var speed:int = 400
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
const Fireball = preload("res://Scenes/fireball.tscn")
var direction = "down"
var shootCooldown = 0.5
var canShoot = true
var canBeHit = true
var hitCooldown = 1
var max_health = 100
var health = max_health
var exp = 0
var max_exp = 100
var level = 1

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	var shootFireball = Input.is_action_pressed("Shoot_Fireball")
	if shootFireball && canShoot:
		var direction = self.global_position.direction_to(get_global_mouse_position())
		shoot(direction)

func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing(): animations.stop()
	else:
		direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		animations.play("walk_" + direction)	
		
func shoot(direction:Vector2):
	canShoot = false
	var fireball = Fireball.instantiate()
	get_parent().add_child(fireball)
	fireball.global_position = global_position
	fireball.rotation = direction.angle()
	
	await get_tree().create_timer(shootCooldown).timeout # wait for cooldown
	canShoot = true

func detectCollisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print("I collided with ", collider.name)
		if collider.get_groups().has("Hostile"):
			hit(collider.damage)

func hit(ammount:int) -> void:
	if canBeHit:
		canBeHit = false
		health -= ammount
		healthChanged.emit()
		effects.play("hurt_blink")
		if health <= 0:
			get_tree().reload_current_scene()
			#get_tree().paused = true
		if get_tree():
			await get_tree().create_timer(hitCooldown).timeout # wait for cooldown
			effects.play("RESET")
			canBeHit = true

func heal(ammount:int)->void:
	health += ammount
	if health > 100:
		health = 100
	healthChanged.emit()
	effects.play("heal")

func gain_exp(ammount:int):
	exp += ammount
	if exp >= max_exp:
		exp = max_exp - ammount
		level_up()
	print(exp)
	expChanged.emit()
	
func level_up():
	level += 1
	max_exp = (level * 100) / 2
	levelUp.emit()

func _physics_process(delta):
	handleInput()
	move_and_slide()
	detectCollisions()
	updateAnimation()
	
