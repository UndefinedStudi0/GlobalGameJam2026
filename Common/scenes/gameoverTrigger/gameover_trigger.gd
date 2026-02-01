extends Node2D
class_name GameOverTrigger

@export var trigger_id: String = "player"
@export var previousCheckpoint = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.set_collision_layer_value(1, false)
	$Area2D.set_collision_mask_value(1, false)
	
	$Area2D.set_collision_mask_value(12, true)
	
	# init interaction group
	if trigger_id != "none":
		InteractionGroups.addInteractionGroup(self, trigger_id)
		
	
	if not $Area2D.body_entered.is_connected(_on_body_entered):
		$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	print("emit gameover event")
	SignalBus.gameover_area_triggered.emit(previousCheckpoint)

func update_trigger_id(newTriggerId: String):
	trigger_id = newTriggerId
	InteractionGroups.addInteractionGroup(self, newTriggerId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
