extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mask/Camera2D.zoom = Vector2(4,4)
	$Mask/Camera2D.position = Vector2.ZERO
	$Mask/Camera2D.offset = Vector2.ZERO
	
	var callable = Callable(self,"dezoom")
	$Mask.jiggle_callback = callable
	$Npc	.process_mode = PROCESS_MODE_DISABLED
	$Mask/Camera2D.position_smoothing_enabled = false
	
func enable_NPC():
	$Npc	.process_mode = Node.PROCESS_MODE_ALWAYS
	$Mask.jiggle_callback = null
	$Mask/Camera2D.position_smoothing_enabled = true
	
func dezoom():
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween()

	tween.tween_property($Mask/Camera2D, "zoom", Vector2(0.8,0.8),3).set_ease(Tween.EASE_OUT) 
	tween.parallel().tween_property($Mask/Camera2D, "offset", Vector2(112,-11),3)
	
	tween.tween_callback(enable_NPC)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
