extends KinematicBody2D

const front := preload("res://sprites/front.png")
const side := preload("res://sprites/side.png")

export (float, 0, 10000) var dx_init = 5
export (float, 0, 10000) var dx = 800
export (float, 0, 1) var ddx_init = 0.01
export (float, 0, 1) var ddx = 0.091
export (float, 0, 1) var dddx = 0.101
export (float, 0, 10000) var dy = 1435.581
export (float, 0, 1) var ddy = 0.435

export (float, 0, 1) var floor_friction = 0.3
export (float, 0, 1) var air_resistance = 0.085
export (float, 0, 10000) var gravity = 4536.424

enum DxMove { DAMP, FLIP, CONTINUE }
enum DyMove { DAMP, PREP, JUMP }

var move_ddx = 0.0
var move_dx_sign = 0.0
var move_dx_abs = 0.0
var move_dy = 0.0
var jump_dy = 0.0

var airborne := false

func input_x():
	var input = 0
	input += -1 if Input.is_action_pressed("ui_left") else 0
	input += 1 if Input.is_action_pressed("ui_right") else 0
	return input

func try_move_flip_x(sign_to):
	if move_dx_sign != sign_to:
		move_dx_sign = sign_to
		move_dx_abs = dx_init
		move_ddx = ddx_init
		return true
	return false

func move_update_x():
	if is_on_floor():
		var input = input_x()
		if input:
			if not try_move_flip_x(input):
				move_ddx = lerp(move_ddx, ddx, dddx) * log(2.5 + dddx)
				move_dx_abs = lerp(move_dx_abs, dx, move_ddx) * log(2.5 + ddx)
				return DxMove.FLIP
			return DxMove.CONTINUE
		else:
			move_dx_abs = lerp(move_dx_abs, 0, floor_friction)
	else:
		move_dx_abs = lerp(move_dx_abs, 0, air_resistance)
	move_ddx = 0
	return DxMove.DAMP

func move_update_y(delta):
	move_dy += gravity * delta
	
func jump_update_y():
	if is_on_floor():
		if Input.is_action_pressed("ui_select"):
			jump_dy = lerp(jump_dy, dy, ddy)
			return DyMove.PREP
		if Input.is_action_just_released("ui_select"):
			move_dy = -jump_dy
			move_dx_abs *= log((move_dx_abs + 1) / 2)
			jump_dy = 0
			return DyMove.JUMP
	else:
		jump_dy = 0
		return DyMove.DAMP

func move_velocity(): 
	return Vector2(move_dx_sign * move_dx_abs, move_dy)

func set_move_velocity(velocity):
	move_dy = velocity.y
	move_dx_sign = sign(velocity.x)
	move_dx_abs = abs(velocity.x)

func _physics_process(delta):
	move_update_y(delta)
	match move_update_x():
		DxMove.FLIP, DxMove.CONTINUE:
			$Sprite.texture = side
			$Sprite.flip_h = move_dx_sign < 0
		DxMove.DAMP:
			$Sprite.texture = front
	match jump_update_y():
		DyMove.PREP:
			$Sprite.rotation = move_dx_sign * PI / 2
		DyMove.JUMP:
			$JumpSound.play()
		DyMove.DAMP:
			$Sprite.rotation = 0
#
	set_move_velocity(move_and_slide(move_velocity(), Vector2.UP))






















