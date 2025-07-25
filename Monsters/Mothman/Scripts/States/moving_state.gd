extends State
class_name MovingState

func OnEnter():
	var enemy: Soundman = state_manager.get_parent()
	enemy.distance -= 1
	print("moved")
	$"../../FootstepsAudio".play()
	if enemy.distance <= 0:
		state_manager.SetState("EnterView")
	else:
		state_manager.SetState("Waiting")
