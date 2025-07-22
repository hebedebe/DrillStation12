extends Node

@export var current_orders: Array[Mission]

var completed_orders: Array[Mission]

var work_done: bool = false

@onready var gamestate: Gamestate = $".."

func on_scan() -> Mission:
	var current_zone = gamestate.drill_manager.drill_sector
	var current_depth = gamestate.drill_manager.drill_depth
	
	var mission = null
	for order in current_orders:
		if order.zone == current_zone:
			if order.depth == current_depth:
				mission = order
	
	if not mission in completed_orders and not mission == null:
		completed_orders.append(mission)
		print("Completed order ", mission)
	return mission

func _process(_delta):
	if not work_done:
		if len(completed_orders) >= len(current_orders):
			work_done = true
			$"Orders Complete".play()

#Signal functions
