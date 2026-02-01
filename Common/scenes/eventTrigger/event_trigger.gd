extends Node2D
class_name EventTrigger

@export var trigger_id: String = "none"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.set_collision_layer_value(1, false)
	$Area2D.set_collision_mask_value(1, false)
	
	$Area2D.set_collision_mask_value(12, true)
	
	# init interaction group
	if trigger_id != "none":
		InteractionGroups.addInteractionGroup(self, trigger_id)

func update_trigger_id(newTriggerId: String):
	trigger_id = newTriggerId
	InteractionGroups.addInteractionGroup(self, newTriggerId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
