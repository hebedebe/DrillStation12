extends Node
class_name StateManager

@export var self_process: bool = true

var state: State
var history: Array[State]

@onready var possible_states: Dictionary[String, State]

func _ready():
	var children = get_children()
	for child in children:
		possible_states[(child as State).GetName()] = child

func _process(delta):
	if self_process and state:
		state.Update(delta)


func SetState(new_state_name: String):
	SetStateNode(GetStateByName(new_state_name))
	
func PushState(new_state_name: String):
	PushStateNode(GetStateByName(new_state_name))

func GetStateByName(state_name: String):
	return possible_states[state_name]

func SetStateNode(new_state: State):
	if state:
		state.OnExit()
	state = new_state
	if state:
		state.OnEnter()
	
func PushStateNode(new_state: State):
	history.append(new_state)
	SetStateNode(new_state)

func PopState():
	history.pop_back()
	SetStateNode(history.back())
