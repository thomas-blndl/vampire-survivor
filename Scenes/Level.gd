extends RichTextLabel

@export var player:Player

func _ready():
	player.levelUp.connect((level_up))
	level_up()

func level_up():
	text = "Level %s" % player.level
