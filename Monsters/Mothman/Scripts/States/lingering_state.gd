extends State
class_name LingeringState

const LINGER_TIME_MIN: float = 4.0
const LINGER_TIME_MAX: float = 7.0

var linger_timer: float = 0.0
var enemy: Soundman

func OnEnter():
	linger_timer = randf_range(LINGER_TIME_MIN, LINGER_TIME_MAX)
	enemy = state_manager.get_parent()
	enemy.reset()

func Update(delta: float):
	var gamestate: Gamestate = get_tree().get_first_node_in_group("Gamestate")
	
	# Check for sound during lingering (triggers jumpscare)
	if enemy.sound_level > enemy.SOUND_MOVE_THRESHOLD or gamestate.power_manager.power:
		state_manager.SetState("Jumpscare")
		return
	
	# Count down linger time
	linger_timer -= delta
	if linger_timer <= 0.0:
		state_manager.SetState("ExitView")
