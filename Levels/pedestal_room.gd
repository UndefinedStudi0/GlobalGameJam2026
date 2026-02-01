extends Node2D

@export var maskRef: Mask = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if maskRef == null:
		maskRef = load("res://Character/mask.tscn").instantiate()
		add_child(maskRef)
		print("instanciating mask manually ")
		print("mask position ", maskRef.global_position)
	
	print("current parent ", maskRef.get_parent())
	maskRef.global_position = $Pedestal.global_position + Vector2(0, -50)
	
	maskRef.get_node("Camera2D").zoom = Vector2(4,4)
	maskRef.get_node("Camera2D").position = Vector2.ZERO
	maskRef.get_node("Camera2D").offset = Vector2.ZERO
	
	var callable = Callable(self,"dezoom")
	
	maskRef.jiggle_callback = callable
	$Npc.process_mode = PROCESS_MODE_DISABLED
	maskRef.get_node("Camera2D").position_smoothing_enabled = false
	
func enable_NPC():

	$Npc.process_mode = Node.PROCESS_MODE_ALWAYS
	maskRef.get_node("Camera2D").position_smoothing_enabled = true
	
func dezoom():
	maskRef.jiggle_callback = null
	#await get_tree().create_timer(4).timeout
	var tween = get_tree().create_tween()

	tween.tween_property(maskRef.get_node("Camera2D"), "zoom", Vector2(0.8,0.8),3).set_ease(Tween.EASE_OUT) 
	tween.parallel().tween_property(maskRef.get_node("Camera2D"), "offset", Vector2(112,-11),3)
	
	tween.tween_callback(enable_NPC)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
