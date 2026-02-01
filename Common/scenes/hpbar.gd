class_name HPBar extends HBoxContainer

@export var allHP: Array[Texture2D] = []
var currentHP = 0

func _ready() -> void:
	# Debug prints
	self.global_position = Vector2(5,5)
	size = Vector2(20 * allHP.size(), 20)
	print("=== HBoxContainer Debug ===")
	print("HBoxContainer visible: ", visible)
	print("HBoxContainer position: ", position)
	print("HBoxContainer size: ", size)
	print("HBoxContainer global_position: ", global_position)
	print("Parent: ", get_parent())
	print("Children count: ", get_child_count())
	
	for i in allHP.size():
		var heart = TextureRect.new()

		heart.texture = allHP[i]
		add_child(heart)
		print("    Type: ", heart.get_class())
		print("    Visible: ", heart.visible)
		print("    Size: ", heart.size)
		if heart is TextureRect:
			print("    Has texture: ", heart.texture != null)
	print("=== HBoxContainer Debug ===")
	print("HBoxContainer visible: ", visible)
	print("HBoxContainer position: ", position)
	print("HBoxContainer size: ", size)
	print("HBoxContainer global_position: ", global_position)
	print("Parent: ", get_parent())
	print("Children count: ", get_child_count())
	currentHP = allHP.size()
	update_simple()

func update_simple():
	for i in get_child_count():
		get_child(i).visible = (i < currentHP)
		print("Setting child ", i, " visible to: ", i < currentHP, "with current hp", currentHP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func decrement():
	print("decrementing HP")
	currentHP-=1
	update_simple()
	if currentHP == 0:
		get_tree().change_scene_to_file("res://Levels/GameOver.tscn")
