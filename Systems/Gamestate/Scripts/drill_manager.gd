extends Node
class_name DrillManager

const DRILL_TIME_PER_KM := 0.1#3.0 # in seconds

var drilling: bool = false
var drill_sector: Vector2i
var drill_depth: int

var drill_progress := 0.0

@onready var gamestate = $".."

# Audio
@onready var drill_sound = $DrillSound

func _process(delta):
	drill_depth = clamp(drill_depth, 1.0, 25.0)
	if drilling and gamestate.power_manager.power:
		drill_progress += delta
		if drilling_complete():
			drilling = false
			on_finish_drilling()

func get_drill_time() -> float:
	return DRILL_TIME_PER_KM * drill_depth + 0.1

func drilling_complete():
	return drill_progress >= get_drill_time()

func on_finish_drilling():
	stop_drilling()
	gamestate.sensors_manager.randomise()

func reset_drilling():
	drill_progress = 0.0

func turn_off():
	stop_drilling()

func toggle_drilling():
	if gamestate.power_manager.power:
		if drilling:
			stop_drilling()
		else:
			start_drilling()
	else:
		stop_drilling()

func start_drilling():
	if gamestate.power_manager.power:
		drilling = true
		drill_sound.play()

func stop_drilling():
	drilling = false
	drill_sound.stop()


# Signal connections

func _on_depth_dial_value_changed(new_value):
	drill_depth = new_value
	reset_drilling()
func _on_x_slider_value_changed(new_value):
	drill_sector.x = new_value
	reset_drilling()
func _on_y_slider_value_changed(new_value):
	drill_sector.y = new_value
	reset_drilling()

func _on_button_button_interacted():
	if not drilling_complete():
		toggle_drilling()
