extends Node2D

var level = preload("res://Levels/level1/level_data.gd").new()

const DOOR_OPENED_CHAT_BOX_ID = "door-opened"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InteractionGroups.addInteractionGroup($Part1/NpcY1Node/NpcY1, "yellow_door")
	# required so it can be detected by the blue door
	$Part1/NpcY1Node/NpcY1.set_collision_layer_value(12, true)
	
	# example chat box closed detection event
	SignalBus.chat_box_closed.connect(_on_need_to_open_the_door_chat_box_close)
	
	# set detection layer 12 (Mask)
	$Part1/DoorOpenedArea2D.set_collision_mask_value(12, true)
	
	# connect the body entered event
	if not $Part1/DoorOpenedArea2D.body_entered.is_connected(_on_close_door_opened_area_2d_body_entered):
		$Part1/DoorOpenedArea2D.body_entered.connect(_on_close_door_opened_area_2d_body_entered)

func _on_need_to_open_the_door_chat_box_close(type: String):
	if type == DOOR_OPENED_CHAT_BOX_ID:
		print("door opened chatbox closed")
		
		
func _on_close_door_opened_area_2d_body_entered(body: Node2D) -> void:
	if !LevelProgress.is_completed(level.name, level.interactions.have_opened_the_door.key):
		var player = $Mask
			
		if player:
			# show the chatbox
			player.showChatBox("The door is now opened!", DOOR_OPENED_CHAT_BOX_ID)
			
			# update the level progression
			LevelProgress.mark_as_completed(level.name, level.interactions.have_opened_the_door)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
