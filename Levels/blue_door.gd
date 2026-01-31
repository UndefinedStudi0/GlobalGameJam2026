extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_collision_mask_value(12, true)
	InteractionGroups.addInteractionGroup(self, "blue_door")
	# Ensure the signal is connected; it's not wired in the scene.
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if InteractionGroups.canInteractWith(self, body):
		print("Can interact with:", body.name)
		
		# run interaction logic
