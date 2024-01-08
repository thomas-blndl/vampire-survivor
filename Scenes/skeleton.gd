extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var player = get_tree().get_nodes_in_group("Player")[0]

var speed = 200
var max_health = 100
var health = max_health
var direction = "down"
var damage = 10
var exp_value = 60

func _ready()-> void:
	set_health_bar()

func set_health_bar() -> void:
	$HealthBar.value = health
	
func hit(ammount:int) -> void:
	health -= ammount
	set_health_bar()
	if health <= 0:
		player.gain_exp(exp_value)
		queue_free()

func _physics_process(delta):
	move(delta)
	move_and_slide()
	updateAnimation()

func move(delta):
	var target = player.global_position
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta *2.5
	velocity += steering

func updateAnimation() -> void:
	if velocity.length() == 0:
		if animations.is_playing(): animations.stop()
	else:
		direction = "down"
		if velocity.x < 0 && velocity.x < velocity.y: direction = "left"
		elif velocity.x > 0 && velocity.x > velocity.y: direction = "right"
		elif velocity.y < 0: direction = "up"
		animations.play("walk_" + direction)	
