extends State
class_name PermanentlyPresentState

func OnEnter():
	var entity = state_manager.get_parent()
	entity.reset_current_dark_time()

func Update(delta: float):
	var entity = state_manager.get_parent()
	
	if entity.is_power_off():
		# Lights are out - entity is visible and dangerous
		entity.sprite.visible = true
		entity.increment_current_dark_time(delta)
		
		# Apply shaking and check for sighting
		entity.apply_shake()
		entity.check_first_sighting()
		
		# Start breathing if not already playing
		if not entity.breathing.playing:
			entity.breathing.play()
		
		# Check for jumpscare
		if entity.get_current_dark_time() >= entity.JUMPSCARE_TIME:
			state_manager.SetState("Jumpscare")
	else:
		# Lights came back on - hide but stay present
		entity.sprite.visible = false
		entity.reset_sprite_position()
		entity.reset_current_dark_time()
		entity.breathing.playing = false

func OnExit():
	var entity = state_manager.get_parent()
	entity.sprite.visible = false
	entity.reset_sprite_position()
	entity.breathing.playing = false
