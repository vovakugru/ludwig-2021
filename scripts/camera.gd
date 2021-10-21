extends Camera2D

export var acceleration := 0.3
export var min_y := 0
export var max_y := 0

onready var player := get_node("../Player")

func _ready():
	position.y = clamp(player.position.y, min_y, max_y)

func _process(delta):
	position.y = lerp(position.y, player.position.y, acceleration)
	position.y = clamp(position.y, min_y, max_y)
