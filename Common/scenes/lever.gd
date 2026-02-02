extends Node2D

@export var leverID : int = 0

var triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$InteractionArea.set_collision_mask_value(12, true)
	
	if not $InteractionArea.body_entered.is_connected(_on_body_entered):
		$InteractionArea.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_body_entered(body: Node) -> void:
	# check if there are nodes with id. action
	if (!triggered):
		trigger()
		
func trigger():
	print("lever_triggered")
	$AnimationPlayer.play("Triggered")
	triggered = true
