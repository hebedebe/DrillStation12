extends Resource
class_name Scan

@export var title: String
@export_multiline var description: String
@export var image: Texture2D

# Max characters per line
const MAX_LINE_LENGTH := 35

func get_wrapped_description(max_length: int = MAX_LINE_LENGTH) -> String:
	var words = description.split(" ")
	var lines := []
	var current_line := ""

	for word in words:
		if current_line.length() + word.length() + 1 <= max_length:
			current_line += ("" if current_line == "" else " ") + word
		else:
			lines.append(current_line)
			current_line = word
	if current_line != "":
		lines.append(current_line)

	return "\n".join(lines)
