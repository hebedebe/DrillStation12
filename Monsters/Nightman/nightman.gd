extends Node3D

const APPROACH_TIME = 30.0 # amount of time the power has to be off for (cumulative) until appearance
const JUMPSCARE_TIME = 5.0 # The amount of time the power can be off for when hes at the window

var present = true
var has_been_seen = false

var timer = 0.0

@onready var sprite = $AtWindow/Sprite
@onready var breathing = $AtWindow/Breathing
@onready var stinger = $Stinger

@onready var gamestate: Gamestate

func _ready():
	gamestate = get_tree().get_first_node_in_group("Gamestate")

func _process(delta):
	if not gamestate.power_manager.power:
		timer += delta
		if not present:
			if timer >= APPROACH_TIME:
				present = true
		else:
			if timer >= JUMPSCARE_TIME:
				pass
	else:
		if present:
			timer = 0.0
		
	
	var should_be_visible = not gamestate.power_manager.power and present
	sprite.visible = should_be_visible
	
	if $VisibleOnScreenNotifier3D.is_on_screen() and sprite.visible and not has_been_seen:	
		has_been_seen = true
		stinger.play()

	if not present:
		breathing.playing = false
	else:
		if not breathing.playing:
			breathing.play()
	
