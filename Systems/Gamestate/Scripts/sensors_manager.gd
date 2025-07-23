extends Node
class_name SensorsManager

@export var target_frequency: int
@export var target_amplitude: int
@export var scan_duration: float = 3.0  # Duration of scan loading in seconds

var current_frequency: int
var current_amplitude: int
var is_scanning: bool = false

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
	return gamestate.power_manager.power and aligned() and gamestate.drill_manager.drilling_complete() and not is_scanning

func scan():
	if ready_to_scan():
		is_scanning = true
		
		# Show loading screen/state
		show_loading_screen()
		
		# Create a timer for the scan duration
		var scan_timer = Timer.new()
		add_child(scan_timer)
		scan_timer.wait_time = scan_duration
		scan_timer.one_shot = true
		scan_timer.timeout.connect(_on_scan_complete)
		scan_timer.start()
		
		print("Scanning... Please wait.")

func _on_scan_complete():
	# Complete the actual scan
	var mission: Mission = gamestate.order_manager.on_scan()
	if mission:
		scanner.current_scan = mission.scan_result
	else:
		scanner.current_scan = empty_scan
		print("Invalid scan location")
	
	# Hide loading screen
	hide_loading_screen()
	is_scanning = false
	
	print("Scan complete!")

func show_loading_screen():
	# Show loading UI elements
	if scanner.has_method("show_loading"):
		scanner.show_loading()
	
	# Alternatively, you could show a loading overlay
	# get_tree().get_first_node_in_group("ui_manager").show_loading_overlay()
	
	# Or disable UI elements during scanning
	var scan_button = get_tree().get_first_node_in_group("scan_button")
	if scan_button:
		scan_button.disabled = true

func hide_loading_screen():
	# Hide loading UI elements
	if scanner.has_method("hide_loading"):
		scanner.hide_loading()
	
	# Re-enable UI elements
	var scan_button = get_tree().get_first_node_in_group("scan_button")
	if scan_button:
		scan_button.disabled = false

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
