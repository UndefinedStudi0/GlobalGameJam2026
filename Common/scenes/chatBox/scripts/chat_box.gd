extends Control

@onready var label := $Panel/VBoxContainer/Label as Label

@export var is_a_talk := true
@export var chat_box_id := ""
@export var toRight := true

const BASE_SCALE := Vector2(0.5, 0.5) # your default scale

var control_mode := "keyboard"
var is_disabled := false
var is_message_displayed := false
var force_hide_button := false

# Cache a stable "toRight" baseline position so flips don't drift / jump
var _base_pos: Vector2
var _base_cached := false


func _ready() -> void:
	# set opacity to 0
	self.modulate.a = 0.0

	_update_control_mode_ui()

	var corner_thought := $"Panel/AspectRatioContainer/Bubble-corner-thought" as Sprite2D
	var corner_talk := $"Panel/AspectRatioContainer/Bubble-corner" as Sprite2D
	corner_thought.visible = !is_a_talk
	corner_talk.visible = is_a_talk

	# Ensure baseline scale is correct before caching
	self.scale = BASE_SCALE

	_update_layout()

	# Cache baseline pose once (assumes current position is your intended "toRight" position)
	_base_pos = self.position
	_base_cached = true


func deactivate_modal() -> void:
	is_disabled = true


func _process(delta: float) -> void:
	# You call _update_layout while visible; it's OK now (idempotent)
	if self.modulate.a > 0.0:
		_update_layout()

	_update_control_mode_ui()

	if !is_message_displayed:
		$Panel/Button.visible = false
	elif control_mode != "keyboard":
		$Panel/Button.visible = true

	if force_hide_button:
		$Panel/Button.visible = false

	if is_message_displayed and !is_disabled and Input.is_action_just_pressed("ui_select"):
		close_chat_box()


func _update_control_mode_ui() -> void:
	var joy_pad_name := Input.get_joy_name(0)

	if joy_pad_name.contains("DualSense"):
		control_mode = "ps"
		$Panel/Button/ps_controller_label.visible = true
		$Panel/Button/xbox_controller_label.visible = false
		$Panel/Button/touch_screen_label.visible = false
		$Panel/Button/StartButton.visible = false
		$Panel/Button.visible = true
	elif joy_pad_name.contains("xbox"):
		control_mode = "xbox"
		$Panel/Button/ps_controller_label.visible = false
		$Panel/Button/xbox_controller_label.visible = true
		$Panel/Button/touch_screen_label.visible = false
		$Panel/Button/StartButton.visible = false
		$Panel/Button.visible = true
	elif OS.has_feature("mobile"):
		control_mode = "touch"
		$Panel/Button/ps_controller_label.visible = false
		$Panel/Button/xbox_controller_label.visible = false
		$Panel/Button/touch_screen_label.visible = true
		$Panel/Button/StartButton.visible = false
		$Panel/Button.visible = true
	else:
		control_mode = "keyboard"
		$Panel/Button.visible = false


func _show_chatbox() -> void:
	if !is_disabled:
		var tween := create_tween()
		if tween:
			tween.tween_property(self, "modulate:a", 1.0, 0.2)  # Fade in

			var player := get_tree().get_first_node_in_group("player") as Player
			if player:
				player.stop_animation()


func _hide_chatbox() -> void:
	var tween := create_tween()
	if tween:
		tween.tween_property(self, "modulate:a", 0.0, 0.2)  # Fade out
		is_message_displayed = false

	var player := get_tree().get_first_node_in_group("player") as Player
	if player:
		player.start_animation()


func write_message(message: String) -> void:
	_show_chatbox()
	_type_text(message, get_tree())


func write_message_with_delay(message: String, delay: int = 0) -> void:
	_show_chatbox()
	_type_text(message, get_tree())

	force_hide_button = true
	await get_tree().create_timer(delay).timeout
	close_chat_box()


func close_chat_box() -> void:
	SignalBus.chat_box_closed.emit(chat_box_id)
	await _hide_chatbox()
	force_hide_button = false


func _type_text(text: String, tree: SceneTree, speed: float = 0.025) -> void:
	label.text = ""
	for c in text:
		label.text += c
		await tree.create_timer(speed).timeout

	is_message_displayed = true
	_update_layout()


func _update_layout() -> void:
	self.z_index = 20

	# ----- Your bubble scaling logic -----
	var topH := $"Panel/AspectRatioContainer/Bubble-up" as Sprite2D
	var bottomH := $"Panel/AspectRatioContainer/Bubble-down" as Sprite2D
	var leftV := $"Panel/AspectRatioContainer/Bubble-left" as Sprite2D
	var rightV := $"Panel/AspectRatioContainer/Bubble-right" as Sprite2D

	var texture_width := topH.texture.get_width()
	var new_scale_x := self.size.x / float(texture_width)
	var x_pos := (texture_width * new_scale_x) / 2.0

	topH.position = Vector2(x_pos, topH.position.y)
	bottomH.position = Vector2(x_pos, bottomH.position.y)
	topH.scale.x = new_scale_x
	bottomH.scale.x = new_scale_x

	var texture_height := rightV.texture.get_height()
	var new_scale_y := self.size.y / float(texture_height)
	var y_pos := (texture_height * new_scale_y) / 2.0

	rightV.position = Vector2(rightV.position.x, y_pos)
	leftV.position = Vector2(leftV.position.x, y_pos)
	rightV.scale.y = new_scale_y
	leftV.scale.y = new_scale_y

	var bubbleCorner := $"Panel/AspectRatioContainer/Bubble-corner" as Sprite2D
	bubbleCorner.position = Vector2((bubbleCorner.texture.get_width() / 2.0) - 4.0, bottomH.position.y + bubbleCorner.texture.get_height() - 15.3)
	bubbleCorner.z_index = 2

	var bubbleCornerThought := $"Panel/AspectRatioContainer/Bubble-corner-thought" as Sprite2D
	bubbleCornerThought.position = Vector2((bubbleCornerThought.texture.get_width() / 2.0) - 12.0, bottomH.position.y + bubbleCornerThought.texture.get_height() - 16.2)
	bubbleCornerThought.z_index = 2

	# ----- Orientation (idempotent; correct text; correct X compensation) -----
	if !_base_cached:
		# If hot-reloaded, recache once
		_base_pos = self.position
		_base_cached = true

	self.scale = BASE_SCALE
	self.pivot_offset = self.size * 0.5

	var s := BASE_SCALE.x # 0.5

	if toRight:
		# Normal orientation: restore baseline pose
		self.scale = BASE_SCALE
		self.position = Vector2(_base_pos.x -  25, _base_pos.y)

		# Text normal
		label.pivot_offset = label.size * 0.5
		label.scale = Vector2(1.0, 1.0)
	else:
		# Mirror bubble
		self.scale = Vector2(-s, BASE_SCALE.y)

		# Compensate position shift caused by mirroring around center pivot
		self.position = Vector2(_base_pos.x - self.size.x * s + 25, _base_pos.y)

		# Un-mirror text (cancel parent's flip)
		label.pivot_offset = label.size * 0.5
		label.scale = Vector2(-1.0, 1.0)


func _unhandled_input(event: InputEvent) -> void:
	if is_message_displayed and not is_disabled:
		if control_mode == "keyboard":
			if event is InputEventKey and event.pressed:
				close_chat_box()
