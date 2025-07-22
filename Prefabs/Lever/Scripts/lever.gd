extends Node3D

@export var start_active: bool = false
@export var can_lock: bool = false

const START_ROTATION: float = 9
const END_ROTATION: float = 171
const SPRING_POWER: float = 10
const TRIGGER_THRESHOLD: float = 0.05

var dragging: bool = false
var openness: float = 0.0
var lever_triggered: bool = false

@onready var pivot = $Lever_Pivot
@onready var start_anchor = $Start
@onready var end_anchor = $End

var viewport: Viewport
var camera: Camera3D

signal on_lever_triggered
signal on_lever_return

func _ready():
	viewport = get_viewport()
	camera = viewport.get_camera_3d()
	if start_active:
		openness = 1.0
		on_lever_triggered.emit()
	else:
		openness = 0.0
		on_lever_return.emit()

func _input(event):
	if event is InputEventMouseMotion and dragging:
		var start_y: float = camera.unproject_position(start_anchor.global_position).y
		var end_y: float = camera.unproject_position(end_anchor.global_position).y
		var mouse_y = viewport.get_mouse_position().y
		openness = (start_y - mouse_y) / (start_y - end_y)

func start_interact() -> void:
	dragging = true
	$Lever_Pivot/LeverHandle/LeverGrab.play(0.0)
	
func stop_interact() -> void:
	dragging = false

func _process(delta):
	if not dragging:
		if (can_lock and openness < 1-TRIGGER_THRESHOLD) or not can_lock:
			openness -= SPRING_POWER * delta
	openness = clampf(openness, 0.0, 1.0)
	if openness < TRIGGER_THRESHOLD:
		if lever_triggered:
			on_lever_return.emit()
			$LeverClunk.play()
			lever_triggered = false
	if not lever_triggered:
		if openness > 1.0-TRIGGER_THRESHOLD:
			lever_triggered = true
			$LeverClunk.play()
			on_lever_triggered.emit()
	pivot.rotation.x = deg_to_rad(lerpf(START_ROTATION, END_ROTATION, progress_to_rotation(openness)))

func progress_to_rotation(progress: float) -> float:
	return ((asin(2*progress - 1) + PI/4)/PI) + 0.25

#Signal connections
func _on_handle_interactor_on_interacted():
	start_interact()
func _on_handle_interactor_on_stop_interact():
	stop_interact()
