extends AudioStreamPlayer

const MIN_DELAY = 20.0
const MAX_DELAY = 60.0

@export var sounds: Array[AudioStream]

var timer: float = 0.0


func _ready():
	timer = randf_range(MIN_DELAY, MAX_DELAY)

func _process(delta):
	timer -= delta
	
	if timer <= 0.0 and not playing:
		timer = randf_range(MIN_DELAY, MAX_DELAY)
		stream = sounds.pick_random()
		play()
