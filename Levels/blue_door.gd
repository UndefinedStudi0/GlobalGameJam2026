extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_collision_layer_value(12, true)
	self.set_collision_mask_value(12, true)
	InteractionGroups.addInteractionGroup(self, "blue_door")


func _on_body_entered(body: Node) -> void:
	if InteractionGroups.canInteractWith(self, body):
		print("Can interact with:", body.name)
	else:
		print("Cannot interact with:", body.name)
