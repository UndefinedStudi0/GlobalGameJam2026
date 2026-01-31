extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mask/Camera2D.zoom = Vector2(4,4)
	$Mask/Camera2D.position = Vector2.ZERO
	$Mask/Camera2D.offset = Vector2.ZERO
	
	var callable = Callable(self,"dezoom")
	$Mask.catch_callback = callable
	
func dezoom():
	$Mask/Camera2D.zoom = Vector2(0.8,0.8)
	$Mask/Camera2D.position = Vector2(100,40)
	$Mask/Camera2D.offset = Vector2(0,-50)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
