extends Node

# Dictionary to track completed interactions per level
var completed_interactions: Dictionary = {}
var last_check_point: Dictionary = {}

# Mark an interaction as completed
func mark_as_completed(level_name: String, interaction: Dictionary) -> void:
	var interaction_key = interaction.key
	var is_checkpoint = interaction.is_checkpoint
	
	if !interaction_key:
		print("ERROR: interaction key is missing")
		return
	
	if not completed_interactions.has(level_name):
		completed_interactions[level_name] = {}
		
	completed_interactions[level_name][interaction_key] = true
	
	print("Marked ", interaction_key, " as completed in level ", level_name)
	
	if is_checkpoint:
		checkpoint()
		

# Check if an interaction is completed
func is_completed(level_name: String, interaction_id: String) -> bool:
	if completed_interactions.has(level_name):
		return completed_interactions[level_name].get(interaction_id, false)
	return false

func checkpoint():
	last_check_point = completed_interactions

# must be triggered on game over
func reset_progress():
	print("resetting state from:")
	print(completed_interactions)

	print("to state:")
	print(last_check_point)
	completed_interactions = last_check_point
	
func restart():
	completed_interactions = {}
	last_check_point = {}

func save_game():
	var save_data = {
		"completed_interactions": completed_interactions,
		"inventory": Inventory.items
	}
	var file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved.")
	
func load_game():
	if not FileAccess.file_exists("user://save_game.json"):
		print("No save file found.")
		return

	var file = FileAccess.open("user://save_game.json", FileAccess.READ)
	var json = JSON.new()
	var save_data = json.parse(file.get_as_text())
	file.close()

	last_check_point = save_data["completed_interactions"]
	Inventory.items = save_data["inventory"]
	print("Game loaded.")
