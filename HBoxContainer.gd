extends HBoxContainer


# Emitted when the `CheckBox` state changes.
signal toggled(is_button_pressed)

# The text of the Label should be changed to identify the setting.
# Using a setter lets us change the text when the `title` variable changes.
@export var title = ""

# We store a reference to the Label node to update its text.
@onready var label = $Label


# Emit the `toggled` signal when the `CheckBox` state changes.
func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("toggled", button_pressed)


# This function will be executed when `title` variable changes.
func set_title(value: String) -> void:
	title = value
	# Wait until the scene is ready if `label` is null.
	if not label:
		yield(self, "ready")
	# Update the label's text
	label.text = title
