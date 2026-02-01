extends Node

# send items array
signal inventory_updated(items)

signal enemy_triggered(type: String)

signal level_ending_sequence()

# chat box action pressed
signal chat_box_closed(chat_box_id: String)

# gameover area body enter
signal gameover_area_triggered(previousCheckpoint: int)
