extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var freeze:bool

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		freeze = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2(Input.get_axis("Left", "Right"),Input.get_axis("Up", "Down")).normalized()
	if direction and !freeze:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
