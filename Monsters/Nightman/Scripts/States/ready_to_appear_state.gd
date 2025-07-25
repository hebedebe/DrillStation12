extends State
class_name ReadyToAppearState

var is_next_outage: bool = false

func OnEnter():
	var entity = state_manager.get_parent()
	entity.sprite.visible = false
	entity.breathing.playing = false
	entity.reset_sprite_position()
	is_next_outage = false

func Update(delta: float):
	var entity = state_manager.get_parent()
	
	if entity.is_power_off() and is_next_outage:
		# Lights went out - now we appear!
		state_manager.SetState("PresentAtWindow")
	else:
		# Still waiting, track time since lights on
		entity.increment_time_since_lights_on(delta)

func turn_on():
	pass
func turn_off():
	is_next_outage = true
