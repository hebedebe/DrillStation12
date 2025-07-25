extends State
class_name NotPresentState

func OnEnter():
	var entity = state_manager.get_parent()
	entity.sprite.visible = false
	entity.breathing.playing = false
	entity.reset_sprite_position()

func Update(delta: float):
	var entity = state_manager.get_parent()
	
	if entity.is_power_off():
		# Accumulate both cumulative and current dark time
		entity.add_to_cumulative_dark_time(delta)
		entity.increment_current_dark_time(delta)
		entity.reset_time_since_lights_on()
		
		# Check if we've accumulated enough dark time - appear immediately!
		if entity.get_cumulative_dark_time() >= entity.APPROACH_TIME:
			state_manager.SetState("ReadyToAppear")
