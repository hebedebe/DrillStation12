extends State
class_name JumpscareStateNightMan

func OnEnter():
	var _entity = state_manager.get_parent()
	print("JUMPSCARE! Player was in the dark too long!")
	
	# Implement jumpscare logic here:
	# - Play jumpscare sound/animation
	# - Trigger game over screen
	# - Disable player controls
	# etc.
	
	# For now, just reset to not present (could also stay permanently present)
	state_manager.SetState("NotPresent")

func Update(_delta: float):
	# Handle jumpscare sequence
	pass
