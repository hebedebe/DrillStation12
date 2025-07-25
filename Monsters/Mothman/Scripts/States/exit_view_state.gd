extends State
class_name ExitView

const EXIT_SPEED: float = 1.0

var enemy: Soundman

# Called when the node enters the scene tree for the first time.
func OnReady():
	enemy = state_manager.get_parent()
	
func OnExit():
	enemy.sprite.visible = false

func Update(delta):
	var direction = enemy.sprite.global_position.direction_to(enemy.end_checkpoint.global_position)
	enemy.sprite.global_position += direction * EXIT_SPEED * delta
	
	if enemy.sprite.global_position.distance_to(enemy.end_checkpoint.global_position):
		state_manager.SetState("Waiting")
