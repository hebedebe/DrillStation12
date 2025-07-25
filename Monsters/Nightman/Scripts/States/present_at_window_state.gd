extends State
class_name PresentAtWindowState

func OnEnter():
	var entity = state_manager.get_parent()
	entity.reset_current_dark_time()
	
	# Start breathing if lights are already out
	if entity.is_power_off() and not entity.breathing.playing:
		entity.breathing.play()

func Update(delta: float):
	var entity = state_manager.get_parent()
	
	if entity.is_power_off():
		# Lights are out - entity is visible and dangerous
		entity.sprite.visible = true
		entity.increment_current_dark_time(delta)
		entity.reset_time_since_lights_on()
		
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
		# Lights came back on
		entity.sprite.visible = false
		entity.reset_sprite_position()
		entity.reset_current_dark_time()
		entity.breathing.playing = false
		entity.increment_time_since_lights_on(delta)
		
		# Check if too much time passed - entity goes back into hiding
		if entity.get_time_since_lights_on() >= entity.COOLDOWN_TIME:
			state_manager.SetState("PermanentlyPresent")

func OnExit():
	var entity = state_manager.get_parent()
	entity.sprite.visible = false
	entity.reset_sprite_position()
	entity.breathing.playing = false
