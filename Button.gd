extends Button

@onready var is_hid = false
@onready var control = $"../Control"

func _ready():
	control.visible = false

func _on_pressed():
	is_hid = not is_hid
	control.visible = is_hid
