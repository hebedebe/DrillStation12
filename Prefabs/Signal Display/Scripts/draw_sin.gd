extends Node2D

const SPEED: float = 4.0
const FREQ_SCALE: float = 0.5
const AMP_SCALE: float = 3.5

@export var draw_colour: Color
@export var draw_offset: Vector2
@export var amplitude := 20.0
@export var frequency := 1.0
@export var phase := 0.0

var enabled: bool = false

func _draw():
	if not enabled:
		return
	var points := []
	var width = 256
	for x in range(0, width):
		var y = sin(x * frequency * FREQ_SCALE * TAU / width + phase) * amplitude * AMP_SCALE
		points.append(Vector2(x+draw_offset.x, y + 128+draw_offset.y))  # 128 to vertically center
	
	for i in points.size() - 1:
		draw_line(points[i], points[i + 1], draw_colour, 2)

func _process(delta):
	if enabled:
		phase += delta * SPEED
		queue_redraw()

func turn_on():
	enabled = true

func turn_off():
	enabled = false
