extends Area2D

@onready var anim:AnimationPlayer = $Sprite2D/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("health_idle")



func _on_body_entered(body):
	if body.name == "Player":
		if body.health < 100:
			body.heal(50)
			queue_free()
