extends Node

# here for reference but needs to be updated with new paths
var audio_streams: Dictionary[String, AudioStreamPlayer2D] = {}
var tweenIn = null
var tweenOut = null

func _ready():
	for key in audio_streams:
		add_child(audio_streams[key])

func play(stream_name: String, volume: float = 1.0):
	set_volume(volume)
	for key in audio_streams:
		if key != stream_name:
			audio_streams[key].stop()
	var target_stream = audio_streams[stream_name]
	if !target_stream.playing:
		target_stream.play()

func _setup_tracks(tracks: Dictionary[String, String]) -> void:
	print("removing old tracks, setting up new tracks")
	print(tracks)
	var audio: Dictionary[String, AudioStreamPlayer2D] = {}
	for track_name in tracks:
	# Start with sound at minimum
		var player = AudioStreamPlayer2D.new()
		player.volume_db = -100
		player.stream = load(tracks[track_name])
		player.stream.loop = true
		audio[track_name] = player
	audio_streams = audio

func percent_to_db(percent: float): 
	return percent * -100
	
# Fade out the specified audio
func cross_fade(fade_duration: float, target_volume: float, in_audio_id: String, out_audio_id: String):
	print("audio cross fade")
	var in_audio = audio_streams[in_audio_id]
	var out_audio = audio_streams[out_audio_id]
	# Start a fade-in from the current volume level
	if in_audio:
		if tweenIn:
			tweenIn.stop()
		tweenIn = create_tween()
		tweenIn.tween_property(in_audio, "volume_db", percent_to_db(target_volume), fade_duration / 2)  # Fade to normal volume (0 dB)
	
	if out_audio:
		# Start a fade-out to silent, stopping playback after the fade
		if tweenOut:
			tweenOut.stop()
		tweenOut = create_tween()
		tweenOut.tween_property(out_audio, "volume_db", -100, fade_duration)  # Fade to silent (-80 dB)

func set_volume(percent: float):
	for track in audio_streams:
		audio_streams[track].volume_db = percent_to_db(percent)

func stop_all():
	for track in audio_streams:
		audio_streams[track].stop()
