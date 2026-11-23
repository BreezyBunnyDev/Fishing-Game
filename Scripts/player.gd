extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var head: Node3D = $Head
var mouse_sensitivity = 0.01
var head_tilt = deg_to_rad(70)
var is_mouse_lock = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_mouse_lock == true:
		rotation.y -= event.relative.x * mouse_sensitivity
		head.rotation.x -= event.relative.y * mouse_sensitivity
		head.rotation.x = clampf(head.rotation.x, -head_tilt, head_tilt)
	if event.is_action_pressed("ui_cancel"):
		if !is_mouse_lock:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			is_mouse_lock = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_mouse_lock = false
			
