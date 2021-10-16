extends Node2D

export var dance_radius: float

func _process(delta):
	var angle = OS.get_ticks_msec() * delta / 2
	var velocity

	if $Sprite.flip_h:
		velocity = Vector2(cos(angle), sin(angle))
	else:
		velocity = -Vector2(sin(angle), cos(angle))
		
	$Sprite.position = velocity * dance_radius

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_UP, KEY_DOWN:
				$Sprite.flip_v = event.scancode == KEY_DOWN
			KEY_LEFT, KEY_RIGHT:
				$Sprite.flip_h = event.scancode == KEY_RIGHT
