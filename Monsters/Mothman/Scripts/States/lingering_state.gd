extends State
class_name LingeringState

var linger_timer: float = 0.0
var enemy: Soundman

func OnEnter():
	linger_timer = 0.0
	enemy = state_manager.get_parent()

func Update(delta: float):
	var gamestate: Gamestate = get_tree().get_first_node_in_group("Gamestate")
	
	# Check for sound during lingering (triggers jumpscare)
	if enemy.sound_level > enemy.SOUND_THRESHOLD or gamestate.power_manager.power:
		state_manager.SetState("Jumpscare")
		return
	
	# Count down linger time
	linger_timer += delta
	if linger_timer >= enemy.LINGER_TIME:
		state_manager.SetState("ExitView")
