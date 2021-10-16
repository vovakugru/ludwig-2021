extends Camera2D

onready var godette = get_node("../Godette")

func _process(_delta):
	position = godette.position
