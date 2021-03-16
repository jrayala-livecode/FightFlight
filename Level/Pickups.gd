extends AudioStreamPlayer

func play_pickup():
	stream = load("res://SFX/lifeup.wav")
	play()

func play_rateup():
	stream = load("res://SFX/rateup.wav")
	play()
