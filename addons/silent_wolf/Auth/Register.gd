extends TextureRect

var stats = Stats

const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

@onready var player_name = $CenterContainer/FormContainer/MainFormContainer/FormInputFields/PlayerName
@onready var email = $CenterContainer/FormContainer/MainFormContainer/FormInputFields/Email
@onready var password = $CenterContainer/FormContainer/MainFormContainer/FormInputFields/Password
@onready var confirm_password = $CenterContainer/FormContainer/MainFormContainer/FormInputFields/ConfirmPassword

@onready var info_box = $CenterContainer/FormContainer/VBoxContainer/InfoBox
@onready var error_message = $CenterContainer/FormContainer/VBoxContainer/ErrorMessage
@onready var processing_label = $CenterContainer/FormContainer/ProcessingLabel

@onready var transition = $transition

func _ready():
	hide_processing_label()
	SilentWolf.check_auth_ready()
	SilentWolf.Auth.sw_registration_complete.connect(_on_registration_complete)
	SilentWolf.Auth.sw_registration_user_pwd_complete.connect(_on_registration_user_pwd_complete)


func _on_RegisterButton_pressed() -> void:
	var p_name = player_name.text
	var _email = email.text
	var pword = password.text
	var confirm_pword = confirm_password.text
	SilentWolf.Auth.register_player(p_name, _email, pword, confirm_pword)
	show_processing_label()


func _on_RegisterUPButton_pressed() -> void:
	var p_name = player_name.text
	var pword = password.text
	var confirm_pword = confirm_password.text
	SilentWolf.Auth.register_player_user_password(p_name, pword, confirm_pword)
	show_processing_label()


func _on_registration_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		registration_success()
	else:
		registration_failure(sw_result.error)


func _on_registration_user_pwd_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		registration_user_pwd_success()
	else:
		registration_failure(sw_result.error)


func registration_success() -> void:
	# redirect to configured scene (user is logged in after registration)
	var scene_name = SilentWolf.auth_config.redirect_to_scene
	# if doing email verification, open scene to confirm email address
	if ("email_confirmation_scene" in SilentWolf.auth_config) and (SilentWolf.auth_config.email_confirmation_scene) != "":
		SWLogger.info("registration succeeded, waiting for email verification...")
		scene_name = SilentWolf.auth_config.email_confirmation_scene
	else:
		SWLogger.info("registration succeeded, logged in player: " + str(SilentWolf.Auth.logged_in_player))
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/ConfirmEmail.tscn")


func registration_user_pwd_success() -> void:
	var scene_name = SilentWolf.auth_config.redirect_to_scene
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/ConfirmEmail.tscn")


func registration_failure(error: String) -> void:
	hide_processing_label()
	error_message.text = error
	error_message.show()

func _on_BackButton_pressed() -> void:
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Login.tscn")

func show_processing_label() -> void:
	processing_label.text = "Processing..."

func hide_processing_label() -> void:
	processing_label.text = ""

func _on_UsernameToolButton_mouse_entered() -> void:
	info_box.text = "Username should contain at least 6 characters (letters or numbers) and no spaces."
	info_box.show()

func _on_UsernameToolButton_mouse_exited() -> void:
	info_box.hide()

func _on_PasswordToolButton_mouse_entered() -> void:
	info_box.text = "Password should contain at least 8 characters including uppercase and lowercase letters, numbers and (optionally) special characters."
	info_box.show()

func _on_PasswordToolButton_mouse_exited() -> void:
	info_box.hide()

func _on_confirmation_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/ConfirmEmail.tscn")
