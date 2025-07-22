extends Node
class_name Interactable

@export var enabled: bool = true

signal on_interacted
signal on_stop_interact

func interact():
	if enabled:
		on_interacted.emit()
	
func stop_interact():
	if enabled:
		on_stop_interact.emit()
