extends State
class_name WaitingState

var enemy: Soundman

func OnEnter():
	enemy = state_manager.get_parent()
	enemy.sprite.global_position = enemy.start_checkpoint.global_position
	enemy.sprite.visible = false

func Update(_delta: float):
	# Check if enough sound has been accumulated
	if enemy.sound_level >= enemy.SOUND_MOVE_THRESHOLD and enemy.move_timer <= 0:
		enemy.reset()
		state_manager.SetState("Moving")
