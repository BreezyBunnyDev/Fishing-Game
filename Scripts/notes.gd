extends Node3D

var tweens = {}

@onready var notes = {
"C": $C,"C#": $C_,
"D": $D,"D#": $D_,
"E": $E,
"F": $F,"F#": $F_,
"G": $G,"G#": $G_,
"A": $A,"A#": $A_,
"B": $B}

func _input(event: InputEvent) -> void:
	for note in notes:
		if event.is_action_pressed(note):
			if tweens.has(note):
				tweens[note].kill()
				
			notes[note].volume_db = -10
			notes[note].play()
			
		elif event.is_action_released(note):
			var tween = create_tween()
			tweens[note]=tween
			tween.tween_property(notes[note],"volume_db",-40,.3)
			tween.tween_callback(notes[note].stop)

func _octave_up():
	pass

func _octave_down():
	pass
