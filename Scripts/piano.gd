extends Control

var colors = {}

@onready var notes = {
"C": $C,"C#": $C_,
"D": $D,"D#": $D_,
"E": $E,
"F": $F,"F#": $F_,
"G": $G,"G#": $G_,
"A": $A,"A#": $A_,
"B": $B}

func _ready() -> void:
	for note in notes:
		colors[note] = notes[note].color

func _input(event: InputEvent) -> void:
	for note in notes:
		if event.is_action_pressed(note):
			notes[note].color = Color.GRAY
		if event.is_action_released(note):
			notes[note].color = colors[note]
