extends Node2D

@export var door_colorid: String = "none"
@export var door_opensonce: bool = true

var door_opened: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match door_colorid:
		"green_door":
			$KeyLight.color = Color(0.0, 1.0, 0.0, 1.0)
		"yellow_door":
			$KeyLight.color = Color(1.0, 1.0, 0.0, 1.0)
		"red_door":
			$KeyLight.color = Color(1.0, 0.0, 0.0, 1.0)
		_:
			$Keypanel.visible = false
			$KeyLight.visible = false
			
	$Area2D.set_collision_mask_value(12, true)
	InteractionGroups.addInteractionGroup(self, door_colorid)
	# Ensure the signal is connected; it's not wired in the scene.
	if not $Area2D.body_entered.is_connected(_on_body_entered):
		$Area2D.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if !door_opened or !door_opensonce:
		if InteractionGroups.canInteractWith(self, body):
			print("Can interact with:", body.name)
			$AnimationPlayer.play("DoorOpens")
			door_opened = true
		
		# run interaction logic
