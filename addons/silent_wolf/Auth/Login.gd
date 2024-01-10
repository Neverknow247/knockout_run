extends TextureRect

var stats = Stats

const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

@onready var username = $CenterContainer/FormContainer/UsernameContainer/Username
@onready var password = $CenterContainer/FormContainer/PasswordContainer/Password
@onready var remember_me_check_box = $CenterContainer/FormContainer/RememberMeCheckBox
@onready var error_message = $CenterContainer/FormContainer/ErrorMessage
@onready var processing_label = $CenterContainer/FormContainer/ProcessingLabel

@onready var transition = $transition

func _ready():
	hide_processing_label()
	SilentWolf.Auth.sw_login_complete.connect(_on_login_complete)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		login()

func _on_LoginButton_pressed() -> void:
	login()

func login():
	var uname = username.text
	var pword = password.text
	var r_me = remember_me_check_box.is_pressed()
	SWLogger.debug("Login form submitted, remember_me: " + str(r_me))
	SilentWolf.Auth.login_player(uname, pword, r_me)
	show_processing_label()

func _on_login_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		login_success()
	else:
		login_failure(sw_result.error)

func login_success() -> void:
	var scene_name = SilentWolf.auth_config.redirect_to_scene
	SWLogger.info("logged in as: " + str(SilentWolf.Auth.logged_in_player))
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file(scene_name)

func login_failure(error: String) -> void:
	hide_processing_label()
	SWLogger.info("log in failed: " + str(error))
	error_message.text = error
	error_message.show()

func show_processing_label() -> void:
	processing_label.text = "Processing..."

func hide_processing_label() -> void:
	processing_label.text = ""

func _on_LinkButton_pressed() -> void:
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file(SilentWolf.auth_config.reset_password_scene)

func _on_back_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file(SilentWolf.auth_config.redirect_to_scene)

func _on_register_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Register.tscn")
