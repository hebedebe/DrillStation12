extends Node
class_name State

var state_manager: StateManager

func _ready():
	var parent = get_parent()
	assert(parent is StateManager)
	state_manager = parent
	OnReady()
	
func OnReady():
	pass

func GetName():
	return name
	
func OnEnter():
	pass
	
func OnExit():
	pass
	
func Update(_delta: float):
	pass
