extends Node2D

@onready var fedness = $E
@onready var playness = $K
@onready var p_pos_reset = 821.5
@onready var f_pos_reset = 317
@onready var p_pos_min = 678.5
@onready var f_pos_min = 174
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var is_dead: bool
@onready var retry = $CanvasLayer/Control/Button3
@onready var question_id: int = -1
@onready var visual_id: int = 0
@onready var options: Array = [
	[
		"Экология - это...",
		1,
		[
			"Совокупность наук о строении Земли, её происхождении и развитии",
			"Наука о взаимодействиях живых организмов между собой и с их средой обитания",
			" Наука о жизни, существовавшей до начала голоценовой эпохи или в её начале в прошлые геологические периоды"
		],
		
	],
	[
		"Что из перечисленных видов мусора разлагается 1000 лет?",
		0,
		[
			"Стекло",
			"Пластик",
			"Полиэтилен"
		],
		
	],
	[
		"Какие из этих твердых бытовых отходов не поддаются переработке?",
		2,
		[
			"Пластиковая тара из‑под бытовой химии",
			"Жестяные банки из‑под газировки",
			"Одноразовые зажигалки",
			"Картонная упаковка для напитков"
		],
		
	],
	[
		"В магазинах нам постоянно предлагают взять пластиковый пакет. Сколько один россиянин берет таких пакетов в год?",
		2,
		[
			"Примерно 50–60",
			"Около 270",
			"Приблизительно 180"
		],
		
	],
	[
		"Можно ли класть одноразовый стаканчик из‑под кофе в контейнер, предназначенный для бумаги?",
		2,
		[
			"Конечно, только предварительно его надо помыть",
			"Можно, и мыть совсем не обязательно",
			"Нет, это бесполезно"
		],
	],
	[
		"О чем говорит этот значок ♻️ ? Его часто размещают на упаковке продуктов.",
		1,
		[
			"Это экологически безопасный продукт",
			"Материал упаковки может быть переработан или упаковка частично/полностью сделана из вторсырья",
			"Производитель уплатил лицензионный сбор и профинансировал сбор и сортировку отходов упаковки"
		],
	],
	[
		"Сколько деревьев можно спасти от вырубки, переработав тонну картона?",
		1,
		[
			"1",
			"17",
			"59"
		],
	],
	[
		"На что хватит энергии, сэкономленной с помощью одной сданной на переработку алюминиевой банки?",
		0,
		[
			"На три часа работы телевизора",
			"На день работы холодильника",
			"На неделю работы обогревателя"
		],
	],
	[
		"Картонная упаковка для молока и соков может быть переработана и использована повторно. Что можно сделать из нее?",
		3,
		[
			"Гофрокартон",
			"Композитные панели для облицовки зданий и строений",
			"Ручки",
			"Все перечисленное"
		],
	],
	[
		"Проекты по переработке отходов внедряются во многих странах мира, в том числе и в России. Какая страна лидирует в этом направлении?",
		0,
		[
			"Германия",
			"Канада",
			"Китай"
		],
	],
	[
		"Сколько бытовых отходов проходят сортировку до попадания на полигон в России?",
		1,
		[
			"Очень мало, не наберется и одного процента",
			"Не более пяти процентов",
			"Процентов десять или около того"
		],
	],
	[
		"Отходы в России делятся на пять классов опасности, из которых I - самый опасный, V - практически безопасный. Какие из ваших возможных отходов причисляются к I классу опасности?",
		1,
		[
			"Батарейка",
			"Ртутный термометр",
			"Моторное масло",
			"Аккумулятор"
		],
	]
]

func _ready():
	Autoload.add_tree()
	animated_sprite_2d.play("idle")
	var player_tree = Autoload.get_player_tree()
	if not player_tree["state"]:
		animated_sprite_2d.visible = false
		is_dead = true
		retry.visible = true
		$AnimatedSprite2D/CanvasLayer/Button.visible = false
		return
	var ticks = (int(Time.get_unix_time_from_system()) - player_tree["fed"]) / 500
	fedness.position.x = f_pos_reset - ticks / 2
	fedness.scale.x = 293 - ticks
	playness.position.x = p_pos_reset - ticks / 2
	playness.scale.x = 293 - ticks
	if fedness.position.x <= f_pos_min or playness.position.x <= p_pos_min:
		die()
	var flag = 0
	for i in Autoload.get_player_requests():
		if i["status"] == 0:
			flag = 1
			Autoload.db.delete_rows("requests", "req_id = " + str(i["req_id"]))
		if i["status"] == 1:
			Autoload.db.delete_rows("requests", "req_id = " + str(i["req_id"]))
	if flag:
		$CanvasLayer/Control/Panel3.visible = true
		die()

func feed():
	animated_sprite_2d.play("eat")
	fedness.position.x = f_pos_reset
	fedness.scale.x = 293
func play():
	playness.position.x = p_pos_reset
	playness.scale.x = 293
func die():
	animated_sprite_2d.play("death")
	Autoload.update_tree(0)
	is_dead = true
	$CanvasLayer/Control/Panel.visible = false
	$AnimatedSprite2D/CanvasLayer/Button.visible = false
func _on_timer_timeout():
	if is_dead:
		return
	fedness.scale.x -= 1
	playness.scale.x -= 1
	fedness.position.x -= 0.5
	playness.position.x -= 0.5
	if fedness.position.x <= f_pos_min or playness.position.x <= p_pos_min:
		die()
	var flag = 0
	for i in Autoload.get_player_requests():
		if i["status"] == 0:
			flag = 1
			Autoload.db.delete_rows("requests", "req_id = " + str(i["req_id"]))
		if i["status"] == 1:
			Autoload.db.delete_rows("requests", "req_id = " + str(i["req_id"]))
	if flag:
		$CanvasLayer/Control/Panel3.visible = true
		die()



func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "eat":
		feed()
		Autoload.update_tree(1, true)
		$AnimatedSprite2D/CanvasLayer/Button.visible = true
		animated_sprite_2d.play("idle")
	if animated_sprite_2d.animation == "death":
		animated_sprite_2d.visible = false
		retry.visible = true


func _on_button_retry_pressed():
	retry.visible = false
	Autoload.update_tree(1, true, true)
	is_dead = false
	$AnimatedSprite2D/CanvasLayer/Button.visible = true
	fedness.position.x = f_pos_reset
	fedness.scale.x = 293
	playness.position.x = p_pos_reset
	playness.scale.x = 293
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("idle")

func _unhandled_input(event):
	if Input.is_action_just_pressed("esc") and $CanvasLayer/Control/Panel.visible:
		$CanvasLayer/Control/Panel.visible = false
	if Input.is_action_just_pressed("esc") and $CanvasLayer/Control/Panel2.visible:
		$CanvasLayer/Control/Panel2.visible = false
		$AnimatedSprite2D/CanvasLayer/Button.visible = true
		animated_sprite_2d.play("idle")
	if Input.is_action_just_pressed("esc") and $CanvasLayer/Control/Panel3.visible:
		$CanvasLayer/Control/Panel3.visible = false


func _on_feed_pressed():
	$AnimatedSprite2D/CanvasLayer/Button.visible = false
	$FileDialog.visible = true



func _on_action_pressed():
	$CanvasLayer/Control/Panel.visible = true


func _on_file_dialog_file_selected(path):
	$CanvasLayer/Control/Panel.visible = false
	var image = FileAccess.get_file_as_bytes(path)
	Autoload.add_image(Autoload.player_id, image)
	animated_sprite_2d.play("eat")
func next_question():
	question_id += 1
	visual_id += 1
	if question_id == len(options):
		question_id = 0
	$CanvasLayer/Control/Panel2/VSplitContainer/VBoxContainer/HBoxContainer/Label2.text = str(visual_id) + "/5"
	$CanvasLayer/Control/Panel2/VSplitContainer/VBoxContainer/Label2.text = options[question_id][0]
	$CanvasLayer/Control/Panel2/VSplitContainer/VBoxContainer/OptionButton.clear()
	for i in options[question_id][2]:
		$CanvasLayer/Control/Panel2/VSplitContainer/VBoxContainer/OptionButton.add_item(i)
	



func _on_play_pressed():
	$AnimatedSprite2D/CanvasLayer/Button.visible = false
	$CanvasLayer/Control/Panel.visible = false
	$CanvasLayer/Control/Panel2.visible = true
	animated_sprite_2d.play("play")
	if question_id > -1:
		question_id -= 1
	next_question()


func _on_option_button_pressed():
	$CanvasLayer/Control/Panel2/VSplitContainer/Label.visible = false


func _on_ok_pressed():

	if $CanvasLayer/Control/Panel2/VSplitContainer/VBoxContainer/OptionButton.selected == options[question_id][1]:
		if question_id > 0 and (question_id + 1) % 5 == 0 or visual_id == 5:
			visual_id = 0
			$AnimatedSprite2D/CanvasLayer/Button.visible = true
			question_id += 1
			play()
			animated_sprite_2d.play("idle")
			$CanvasLayer/Control/Panel2.visible = false
		else:
			next_question()
	else:
		$CanvasLayer/Control/Panel2/VSplitContainer/Label.visible = true
