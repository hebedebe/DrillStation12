extends Light3D

var light_flicker: LightFlicker

func _ready():
	light_flicker = get_parent()
	
func _process(delta):
	light_energy = light_flicker.brightness
