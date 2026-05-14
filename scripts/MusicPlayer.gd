extends AudioStreamPlayer

func play_music(music_stream: AudioStream):
	if stream == music_stream:
		return 
	
	stream = music_stream
	play()
