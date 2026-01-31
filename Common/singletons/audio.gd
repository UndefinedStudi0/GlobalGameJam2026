extends Node

var safe_music = AudioStreamPlayer2D.new()
var danger_music = AudioStreamPlayer2D.new()
var cutscene_music = AudioStreamPlayer2D.new()
const fade_duration = 2.0  # Duration of the fade in seconds
# here for reference but needs to be updated with new paths
var levels = {"stable": ["res://Assets/MASK puzzle v1.mp3",
						"res://Assets/MASK sombre v1.mp3",
						"res://Assets/MASK sombre v1.mp3"],
			  "monastery": ["res://levels/1_monastery/assets/audios/level_2_main.mp3", 
							"res://levels/1_monastery/assets/audios/level_2_danger.mp3",
							"res://common/audio/CUTSCENE 2.mp3"]}

var current_level = ""

func _ready():
	add_child(safe_music)
	add_child(danger_music)
	add_child(cutscene_music)

	safe_music.volume_db = -20

func _setup_level(levelName: String) -> void:
	print("setting up audio for level " + levelName)
	if current_level == levelName:
		return
	var lookupLevel = levels[levelName]
	if !lookupLevel:
		print("level not found")
	
	_setup_tracks(lookupLevel[0], lookupLevel[1], lookupLevel[2])
	current_level = levelName

func _setup_tracks(safe: String, danger: String, cutscene: String) -> void:
	print("setting up tracks")
	# Start with sound at minimum
	safe_music.volume_db = -100
	danger_music.volume_db = -100
	safe_music.stream = load(safe)
	danger_music.stream = load(danger)
	cutscene_music.stream = load(cutscene)
	safe_music.stream.loop = true
	danger_music.stream.loop = true
	await get_tree().create_timer(0.5).timeout
	safe_music.play()
	danger_music.play()

# Fade out the specified audio
func fade_audios(in_audio: AudioStreamPlayer2D, out_audio: AudioStreamPlayer2D):
	print("audio cross fade")

	# Start a fade-in from the current volume level
	if in_audio:
		var tweenIn = create_tween()
		tweenIn.tween_property(in_audio, "volume_db", 0, fade_duration / 2)  # Fade to normal volume (0 dB)
	
	if out_audio:
		# Start a fade-out to silent, stopping playback after the fade
		var tweenOut = create_tween()
		tweenOut.tween_property(out_audio, "volume_db", -100, fade_duration)  # Fade to silent (-80 dB)

func fadein_danger() -> void:
	print("cross fade from safe to danger")

	fade_audios(danger_music, safe_music)

func fadein_safe() -> void:
	print("cross fade from danger to safe")
	fade_audios(safe_music, danger_music)
	
func fadein_cutscene() -> void:
	print("starting cutscene music")
	stop_all()
	cutscene_music.play()
	
func stop_all():
	fade_audios(null, safe_music)
	fade_audios(null, danger_music)
