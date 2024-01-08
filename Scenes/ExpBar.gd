extends ProgressBar

@export var player:Player

func _ready():
	player.expChanged.connect(update)
	player.levelUp.connect((level_up))
	update()
	level_up()

func update():
	value = player.exp

func level_up():
	max_value = player.max_exp
