extends State
class_name EnterView

const ENTER_SPEED: float = 1.0

var enemy: Soundman

# Called when the node enters the scene tree for the first time.
func OnReady():
	enemy = state_manager.get_parent()

func OnEnter():
	enemy.sprite.global_position = enemy.start_checkpoint.global_position
	enemy.sprite.visible = true

func Update(delta):
	var direction = enemy.sprite.global_position.direction_to(enemy.middle_checkpoint.global_position)
	enemy.sprite.global_position += direction * ENTER_SPEED * delta
	
	if enemy.sprite.global_position.distance_to(enemy.middle_checkpoint.global_position):
		state_manager.SetState("Lingering")
