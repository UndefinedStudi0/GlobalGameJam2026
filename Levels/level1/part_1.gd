extends Node2D

var level = preload("res://Levels/level1/level_data.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var NpcTriggerAlert = $NpcAlertTrigger as EventTrigger
	var Checkpoint1 = $Checkpoint1 as EventTrigger
	var NpcTriggerAlertArea2d = $NpcAlertTrigger/Area2D
	var Checkpoint1Area2D = $Checkpoint1/Area2D
	
	# ensure only the player can trigger this area
	NpcTriggerAlert.update_trigger_id("player")
	Checkpoint1.update_trigger_id("player")
	
	# connect the body entered event
	if not NpcTriggerAlertArea2d.body_entered.is_connected(_on_npc_trigger_alert_area_entered):
		NpcTriggerAlertArea2d.body_entered.connect(_on_npc_trigger_alert_area_entered)
		
	if not Checkpoint1Area2D.body_entered.is_connected(_on_checkpoint_one_area_entered):
		Checkpoint1Area2D.body_entered.connect(_on_checkpoint_one_area_entered)
		
		
func _on_npc_trigger_alert_area_entered(body: Node2D) -> void:
	if !LevelProgress.is_completed(level.name, level.interactions.npc_trigger_alert.key):
		# update the level progression
		LevelProgress.mark_as_completed(level.name, level.interactions.npc_trigger_alert)
		
		var npcTriggeringTheAlert = $NpcY1Node/NpcY1 as Npc
		var npcFinalPositionMarker = $NpcY1Node/PatrolLeft
		var player = get_parent().get_tree().get_first_node_in_group("player")
		
		if !npcTriggeringTheAlert:
			print("npcTriggeringTheAlert not found")
			return
			
		if !player:
			print("player not found")
			return

		# 1. player cannot move anymore
		player.are_movements_disabled = true
		
		# 2. npc show message
		await npcTriggeringTheAlert.showChatBox("Someone is stealing the mask!", "npc-trigger-alarm", 2)
		
		# 3. npc move behing the door			
		npcTriggeringTheAlert.speed = 300
		npcTriggeringTheAlert.waypoints.append(npcFinalPositionMarker)
		
		# 4. back to normal state
		player.are_movements_disabled = false
			
func _on_checkpoint_one_area_entered(body: Node2D) -> void:
	# trigger a checkpoint => save location and npc used
	if !LevelProgress.is_completed(level.name, level.interactions.first_checkpoint.key):
		LevelProgress.mark_as_completed(level.name, level.interactions.first_checkpoint)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
