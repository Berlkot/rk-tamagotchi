extends Button

func _on_pressed():
	$"../Control2".visible = not $"../Control2".visible
	$"../Control2/VSplitContainer/Label".text = Autoload.player_login
	$"../Control2/VSplitContainer/VBoxContainer/HBoxContainer/Label".text = str(Autoload.player_id)
