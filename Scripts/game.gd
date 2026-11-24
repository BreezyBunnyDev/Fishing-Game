extends Node3D

const SKILL_CHECK = preload("uid://ctdi3a5pktbwx")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
		
var fish_type = {"Common":.54,"Uncommon":.25,"Rare":.15,"Epic":.05,"Legendary":.01}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fish"):
		var percent = snapped(randf(),.001)
		var fish = "Common"
		var chance = 0
		
		for rarity in fish_type:
			chance += fish_type[rarity]
			if percent < chance:
				fish = rarity
				break
			
		print(fish)
		print(1-percent)
		
		if fish == "Common":
			var skill_check = SKILL_CHECK.instantiate()
			add_child(skill_check)
