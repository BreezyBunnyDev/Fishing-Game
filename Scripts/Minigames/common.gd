extends Control

@onready var container: HBoxContainer = $HBoxContainer
@onready var quarter_note: Timer = $QuarterNote
@onready var grace: Timer = $Grace
@onready var texture_rect: TextureRect = $TextureRect

var note = 0
var tempo = 100
var can_hit = false
var finished = false
var grace_length
var beat = 0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Skill Check") and !finished:
		quarter_note.stop()
		if can_hit:
			_hit()
		else:
			_miss()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beat = 60.0/tempo
	grace_length = beat/3
	quarter_note.wait_time = beat
	quarter_note.start()


func _on_timer_timeout() -> void:
	if note>0:
		container.get_child(note-1).modulate = Color(0,0,0)
	container.get_child(note).modulate = Color(1,1,1)
	note += 1
	
	if note == container.get_child_count()-1:
		grace.wait_time = beat - grace_length
		grace.start()
	
	if note == container.get_child_count():
		quarter_note.stop()


func _on_grace_timeout() -> void:
	if finished:
		return
	if !can_hit:
		can_hit=true
		grace.wait_time = grace_length * 2
		grace.start()
	else:
		_miss()

func _miss():
	finished = true
	can_hit = false
	texture_rect.modulate = Color(1,0,0)
	await get_tree().create_timer(1).timeout
	queue_free()

func _hit():
	finished = true
	can_hit = false
	texture_rect.modulate = Color(0,1,0)
	await get_tree().create_timer(1).timeout
	queue_free()
