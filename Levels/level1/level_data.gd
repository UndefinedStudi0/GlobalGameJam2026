@export var name = "ChapterOne"

# the global level interactions, this script is imported globally
@export var interactions: Dictionary = {
	"have_opened_the_door": {
		"key": "have_opened_the_door",
		"is_checkpoint": false,
		# "items_equired": ["item-key"]
	},
	"npc_trigger_alert": {
		"key": "npc_trigger_alert",
		"is_checkpoint": false,
	},
	"first_checkpoint": {
		"key": "first_checkpoint",
		"is_checkpoint": true,
	}
}
