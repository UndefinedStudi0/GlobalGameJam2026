class_name Player extends NewtonPhysics

func _ready() -> void:
	# necessary for "var player = get_tree().get_first_node_in_group("player") as Player" in chat_box.gd
	add_to_group("player")
