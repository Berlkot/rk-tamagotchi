extends Node2D

@onready var db: SQLite = SQLite.new()
@onready var player_id: int
@onready var player_login: String

func _ready():
	db.path = "user://my_database"
	db.open_db()
	create_table()

func create_table():
	var table_name = "logins"
	var table_dict : Dictionary = Dictionary()
	table_dict["id"] = {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment":true}
	table_dict["login"] = {"data_type":"char(50)", "not_null": true}
	table_dict["email"] = {"data_type":"char(100)", "not_null": true}
	table_dict["password"] = {"data_type":"char(50)", "not_null": true}
	db.create_table(table_name, table_dict)
	table_name = "pets"
	table_dict = Dictionary()
	table_dict["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
	table_dict["state"] = {"data_type":"int", "not_null": true}
	table_dict["fed"] = {"data_type":"int", "not_null": true}
	table_dict["play"] = {"data_type":"int", "not_null": true}
	db.create_table(table_name, table_dict)
	table_name = "requests"
	table_dict = Dictionary()
	table_dict["req_id"] = {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment":true}
	table_dict["id"] = {"data_type":"int", "not_null": true}
	table_dict["status"] = {"data_type":"int", "not_null": true}
	table_dict["image"] = {"data_type":"blob", "not_null": true}
	db.create_table(table_name, table_dict)

func add_player(login, email, password):
	var table_name = "logins"
	var table_dict : Dictionary = Dictionary()
	table_dict["login"] = login
	table_dict["email"] = email
	table_dict["password"] = password
	db.insert_row(table_name, table_dict)
	db.query("SELECT MAX(id) AS max_id FROM logins")
	player_login = login
	player_id = db.query_result[0]["max_id"]

func get_player_by_id(id: String) -> Dictionary:
	db.query_with_bindings("SELECT * FROM logins WHERE id = ?", [id])
	if db.query_result:
		return db.query_result[0]
	else:
		return {}
func get_player_by_login(login: String) -> Dictionary:
	db.query_with_bindings("SELECT * FROM logins WHERE login = ?", [login])
	if db.query_result:
		return db.query_result[0]
	else:
		return {}
func get_player_by_email(email: String) -> Dictionary:
	db.query_with_bindings("SELECT * FROM logins WHERE email = ?", [email])
	if db.query_result:
		return db.query_result[0]
	else:
		return {}

func add_tree():
	var table_name = "pets"
	var table_dict : Dictionary = Dictionary()
	table_dict["id"] = player_id
	table_dict["state"] = 1
	table_dict["fed"] = int(Time.get_unix_time_from_system())
	table_dict["play"] = int(Time.get_unix_time_from_system())
	db.insert_row(table_name, table_dict)

func get_player_tree() -> Dictionary:
	db.query_with_bindings("SELECT * FROM pets WHERE id = ?", [player_id])
	if db.query_result:
		return db.query_result[0]
	else:
		return {}
func get_player_requests() -> Array:
	db.query_with_bindings("SELECT * FROM requests WHERE id = ?", [player_id])
	if db.query_result:
		return db.query_result
	else:
		return []

func update_tree(dead: bool, fed: bool = false, play: bool = false):
	var table_name = "pets"
	var table_dict : Dictionary = Dictionary()
	table_dict["state"] = int(dead)
	if fed:
		table_dict["fed"] = int(Time.get_unix_time_from_system())
	if play:
		table_dict["play"] = int(Time.get_unix_time_from_system())
	db.update_rows(table_name, "id = " + str(player_id), table_dict)

func add_image(id, image: PackedByteArray):
	var table_name = "requests"
	var table_dict : Dictionary = Dictionary()
	table_dict["id"] = id
	table_dict["status"] = 2
	table_dict["image"] = image
	db.insert_row(table_name, table_dict)
