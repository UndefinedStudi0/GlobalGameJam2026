extends Node2D

var level = preload("res://Levels/level1/level_data.gd").new()

const DOOR_OPENED_CHAT_BOX_ID = "door-opened"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InteractionGroups.addInteractionGroup($Part1/NPCsFolder/NpcY1Node/NpcY1, "yellow_door")
	# required so it can be detected by the blue door
	$Part1/NPCsFolder/NpcY1Node/NpcY1.set_collision_layer_value(12, true)
	
	# set detection layer 12 (Mask)
	$Part1/DoorOpenedArea2D.set_collision_mask_value(12, true)
	
	# connect the body entered event
	if not $Part1/DoorOpenedArea2D.body_entered.is_connected(_on_close_door_opened_area_2d_body_entered):
		$Part1/DoorOpenedArea2D.body_entered.connect(_on_close_door_opened_area_2d_body_entered)
		
	# enable events for gameover areas	
	SignalBus.gameover_area_triggered.connect(_on_gameover_area_body_enter)
	
	Audio._setup_level("museum")
	Audio.fadein_safe()
		
func _on_gameover_area_body_enter(previousCheckpoint: int) -> void:
	# move the user to the checkpoint
	LevelProgress.reset_progress()
	
	var checkpointPosition: Vector2 = Vector2(0,0)
	
	match previousCheckpoint:
		0:
			checkpointPosition = $Part1/Checkpoint0.position	
		1:
			checkpointPosition = $Part1/Checkpoint1.position
		2:
			checkpointPosition = $Part2/Checkpoint2.position
		3:
			checkpointPosition = $Part3/Checkpoint3.position
			
	var mask = $Mask
	
	mask.hp_bar.decrement()
	
	# reset mask position
	mask.position = checkpointPosition

	# reset npcs positions
	var tree = get_tree()
	
	if tree:
		var npcs = tree.get_nodes_in_group("npc")
		
		for npc in npcs:
			npc.global_position = npc.initial_global_position
		
	
		
func _on_close_door_opened_area_2d_body_entered(body: Node2D) -> void:
	if !LevelProgress.is_completed(level.name, level.interactions.have_opened_the_door.key):
		LevelProgress.mark_as_completed(level.name, level.interactions.have_opened_the_door)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
