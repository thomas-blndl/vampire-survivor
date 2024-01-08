extends Area2D

@onready var anim:AnimationPlayer = $FireBall2/AnimationPlayer
@export var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("fireball_launch")
	
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fireball_launch":
		anim.play("fireball_flying")

func _on_body_entered(body):
	if body.name == "TileMap":
		queue_free()
	if body.is_in_group("Hostile"):
		body.hit(20)
		queue_free()
