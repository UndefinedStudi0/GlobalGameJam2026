extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InteractionGroups.addInteractionGroup($Node2D3/NpcY1, "yellow_door")
	# required so it can be detected by the blue door
	$Node2D3/NpcY1.set_collision_layer_value(12, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
