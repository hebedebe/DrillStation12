extends Node3D

const APPROACH_TIME = 30.0 # amount of time the power has to be off for (cumulative) until appearance
const JUMPSCARE_TIME = 7.0 # The amount of time the power can be off for when hes at the window
const MAX_SHAKE_INTENSITY = 0.01 # Maximum shake distance in pixels

var present = false
var has_been_seen = false
var timer = 0.0
var original_position: Vector3

@onready var sprite = $AtWindow/Sprite
@onready var breathing = $AtWindow/Breathing
@onready var stinger = $Stinger
@onready var gamestate: Gamestate

func _ready():
	gamestate = get_tree().get_first_node_in_group("Gamestate")
	# Store the original position of the sprite
	original_position = sprite.position

func _process(delta):
	if not gamestate.power_manager.power:
		timer += delta
		if not present:
			if timer >= APPROACH_TIME:
				present = true
				timer = 0.0
		else:
			if timer >= JUMPSCARE_TIME:
				pass
	else:
		if present:
			timer = 0.0
		
	var should_be_visible = not gamestate.power_manager.power and present
	sprite.visible = should_be_visible
	
	# Apply progressive shaking when sprite is visible and present
	if should_be_visible and present:
		apply_shake()
	else:
		# Reset to original position when not shaking
		sprite.position = original_position
	
	if $VisibleOnScreenNotifier3D.is_on_screen() and sprite.visible and not has_been_seen:	
		has_been_seen = true
		stinger.play()
	
	if not present:
		breathing.playing = false
	else:
		if not breathing.playing:
			breathing.play()

func apply_shake():
	# Calculate shake intensity based on how close we are to jumpscare
	var shake_progress = timer / JUMPSCARE_TIME
	shake_progress = clamp(shake_progress, 0.0, 1.0)
	
	# Use exponential curve for more dramatic effect as timer approaches jumpscare
	var intensity = pow(shake_progress, 2) * MAX_SHAKE_INTENSITY
	
	# Generate random offset for 3D space
	var shake_x = randf_range(-intensity, intensity)
	var shake_y = randf_range(-intensity, intensity)
	var shake_z = randf_range(-intensity, intensity)
	
	# Apply shake to sprite position
	sprite.position = original_position + Vector3(shake_x, shake_y, shake_z)
