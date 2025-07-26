extends Node3D
class_name Soundman

const SOUND_MOVE_THRESHOLD: float = 1.0 # the sound level required to move
const STEPS_TO_PLAYER: int = 5 # number of times the threshold can be exceeded before moving
const SOUND_FADE_SPEED: float = 1.0
const MOVE_COOLDOWN: float = 0.0

var sound_level: float = 0.0
var distance: int = STEPS_TO_PLAYER
var move_timer: float = 0.0

var current_target_checkpoint: Node3D
var warning_played: bool = false

signal sound_added

@onready var state_machine = $StateManager

@onready var sprite = $Sprite

@onready var start_checkpoint = $Checkpoints/StartCheckpoint
@onready var middle_checkpoint = $Checkpoints/MiddleCheckpoint
@onready var end_checkpoint = $Checkpoints/EndCheckpoint

func _ready():
	state_machine.SetState("Waiting")
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			add_sound(1.0)

func _process(delta):
	sound_level -= SOUND_FADE_SPEED * delta
	sound_level = maxf(sound_level, 0.0)
	
	move_timer -= delta

func reset():
	sound_level = 0.0
	move_timer = MOVE_COOLDOWN

func add_sound(amount: float):
	sound_level += amount
	sound_added.emit(amount)
