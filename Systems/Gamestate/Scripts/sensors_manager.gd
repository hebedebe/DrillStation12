extends Node
class_name SensorsManager

@export var target_frequency: int
@export var target_amplitude: int

var current_frequency: int
var current_amplitude: int

@onready var empty_scan = preload("res://Missions/scans/empty_scan.tres")

@onready var base_signal
@onready var input_signal

@onready var scanner

@onready var gamestate = $".."

func _ready():
	base_signal = get_tree().get_first_node_in_group("base_signal")
	input_signal = get_tree().get_first_node_in_group("input_signal")
	scanner = get_tree().get_first_node_in_group("scanner")
	randomize()
	randomise()
	
func randomise():
	target_frequency = randi_range(1, 20)
	target_amplitude = randi_range(1, 20)

func aligned() -> bool:
	return current_frequency == target_frequency and current_amplitude == target_amplitude

func ready_to_scan() -> bool:
	return gamestate.power_manager.power and aligned() and gamestate.drill_manager.drilling_complete()

func scan():
	if ready_to_scan():
		var mission: Mission = gamestate.order_manager.on_scan()
		if mission:
			scanner.current_scan = mission.scan_result
		else:
			scanner.current_scan = empty_scan
			print("Invalid scan location")

func _process(_delta):
	base_signal.frequency = target_frequency
	base_signal.amplitude = target_amplitude

# Signal connections
func _on_frequency_dial_value_changed(new_value):
	current_frequency = new_value
func _on_amplitude_dial_value_changed(new_value):
	current_amplitude = new_value

func _on_button_button_interacted():
	scan()
