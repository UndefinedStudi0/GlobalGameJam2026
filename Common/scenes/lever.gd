extends Node2D
class_name lever

@export var leverID : int = 0

var triggered: bool = false
@export var actionables: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$InteractionArea.set_collision_mask_value(12, true)
	
	if not $InteractionArea.body_entered.is_connected(_on_body_entered):
		$InteractionArea.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if (!triggered):
		trigger()

func trigger():
	print("lever_triggered")
	$AnimationPlayer.play("Triggered")
	triggered = true
	
	for element in actionables:
		element.lever_action()
	
	# check if there are nodes with id for action
	#if leverID > 0:
		#var impactednodes = get_tree().get_nodes_in_group(str("can_interact_with_","lever-group-",leverID))
		#for impactednode in impactednodes:
			#if impactednode.has_method("lever_action"):
				#impactednode.lever_action()
