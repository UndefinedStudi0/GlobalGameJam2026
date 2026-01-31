extends Node2D

func _ready() -> void:
	# get npc
	var npc = get_tree().get_first_node_in_group("npc")

	if npc != null && npc.name == "Npc":
		# only this npc can interact with the blue door because of this line
		InteractionGroups.addInteractionGroup(npc, "blue_door")
		# required so it can be detected by the blue door
		npc.set_collision_layer_value(12, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
