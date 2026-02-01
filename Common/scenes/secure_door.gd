extends Node2D

@export var door_colorid: String = "none"
@export var door_opensonce: bool = true

var door_opened: bool = false

var animation_end_callback = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match door_colorid:
		"green_door":
			$KeypassGreen.visible = true
			$KeypassYellow.visible = false
		"yellow_door":
			$KeypassGreen.visible = false
			$KeypassYellow.visible = true
		_:
			$KeypassGreen.visible = false
			$KeypassYellow.visible = false
	$AnimationPlayer.animation_finished.connect(animation_ended)

	$Area2D.set_collision_mask_value(12, true)
	InteractionGroups.addInteractionGroup(self, door_colorid)
	# Ensure the signal is connected; it's not wired in the scene.
	if not $Area2D.body_entered.is_connected(_on_body_entered):
		$Area2D.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func animation_ended():
	print("animation ended")
	if animation_end_callback:
		animation_end_callback.call()

func _on_body_entered(body: Node) -> void:
	if !door_opened or !door_opensonce:
		if InteractionGroups.canInteractWith(self, body):
			print("Can interact with2:", body.name)
			$AnimationPlayer.play("DoorOpens")
			door_opened = true

			await get_tree().create_timer(2.0).timeout
			animation_ended()
		
		# run interaction logic
