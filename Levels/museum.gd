extends Node2D

func _ready() -> void:
	Audio._setup_level("museum")
	Audio.fadein_safe()
	pass # Replace with function body.

	# only this npc can interact with the blue door because of this line
	InteractionGroups.addInteractionGroup($Npc, "blue_door")
	# required so it can be detected by the blue door
	$Npc.set_collision_layer_value(12, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
