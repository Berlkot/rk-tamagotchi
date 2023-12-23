extends Panel

enum State {
	LOGIN,
	REGISTER
}
@onready var state = State.LOGIN
@onready var label = $VBoxContainer/Label
@onready var login = $VBoxContainer/LineEdit
@onready var mail = $VBoxContainer/LineEdit3
@onready var password = $VBoxContainer/LineEdit2
@onready var mail_re = RegEx.new()


func _ready():
	mail_re.compile(r"(?:[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])")
	if state == State.LOGIN:
		label.text = "Логин/Почта"
		$VBoxContainer/Label3.visible = false
		$VBoxContainer/LineEdit3.visible = false
		


func _on_button_pressed():
	$VBoxContainer/Label4.visible = false
	$VBoxContainer/Label5.visible = false
	$VBoxContainer/Label6.visible = false
	if state == State.LOGIN:
		var tmp_log = login.text
		if not tmp_log:
			$VBoxContainer/Label4.visible = true
			$VBoxContainer/Label4.text = "Пустое поле"
			return
		var tmp_pswd = password.text
		if not tmp_pswd:
			$VBoxContainer/Label6.visible = true
			$VBoxContainer/Label6.text = "Пустое поле"
			return
		var player = Autoload.get_player_by_login(tmp_log)
		if not player:
			player = Autoload.get_player_by_email(tmp_log)
		if not player:
			$VBoxContainer/Label4.visible = true
			$VBoxContainer/Label4.text = "Пользователь не найден"
			return
		if tmp_pswd != player["password"]:
			$VBoxContainer/Label6.visible = true
			$VBoxContainer/Label6.text = "Неверный пароль"
			return
		Autoload.player_id = player["id"]
		Autoload.player_login = player["login"]
		get_tree().change_scene_to_file("res://main_menu.tscn")
	else:
		var tmp_log = login.text
		if not tmp_log:
			$VBoxContainer/Label4.visible = true
			$VBoxContainer/Label4.text = "Пустое поле"
			return
		var tmp_mail = mail.text
		if not tmp_mail:
			$VBoxContainer/Label5.visible = true
			$VBoxContainer/Label5.text = "Пустое поле"
			return
		var tmp_pswd = password.text
		if not tmp_pswd:
			$VBoxContainer/Label6.visible = true
			$VBoxContainer/Label6.text = "Пустое поле"
			return
		if len(tmp_pswd) < 5:
			$VBoxContainer/Label6.visible = true
			$VBoxContainer/Label6.text = "Пароль должен состоять минимум из 5 символов"
			return
		var result = mail_re.search(tmp_mail)
		if not result or result.get_string() != tmp_mail:
			$VBoxContainer/Label5.visible = true
			$VBoxContainer/Label5.text = "Некорректная почта"
			return
		var player = Autoload.get_player_by_login(tmp_log)
		if player:
			$VBoxContainer/Label4.visible = true
			$VBoxContainer/Label4.text = "Пользователь с таким именем уже существует"
			return
		player = Autoload.get_player_by_email(tmp_mail)
		if player:
			$VBoxContainer/Label5.visible = true
			$VBoxContainer/Label5.text = "Пользователь с этой почтой уже существует"
			return
		Autoload.add_player(tmp_log, tmp_mail, tmp_pswd)
		get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_button_2_pressed():
	$VBoxContainer/Label4.visible = false
	$VBoxContainer/Label5.visible = false
	$VBoxContainer/Label6.visible = false
	login.text = ""
	mail.text = ""
	password.text = ""
	if state == State.LOGIN:
		state = State.REGISTER
		$VBoxContainer/HBoxContainer/Button.text = "Создать"
		label.text = "Логин"
		$VBoxContainer/HBoxContainer/Button2.text = "Вход"
		$VBoxContainer/Label3.visible = true
		$VBoxContainer/LineEdit3.visible = true
	else:
		state = State.LOGIN
		$VBoxContainer/HBoxContainer/Button2.text = "Регистрация"
		$VBoxContainer/HBoxContainer/Button.text = "Войти"
		label.text = "Логин/Почта"
		$VBoxContainer/Label3.visible = false
		$VBoxContainer/LineEdit3.visible = false
