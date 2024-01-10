extends TextureRect

var stats = Stats

const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

@onready var verif_username = $FormContainer/UsernameContainer/VerifUsername
@onready var transition = $transition

func _ready():
	hide_processing_label()
	if SilentWolf.Auth.tmp_username != null:
		verif_username.text = SilentWolf.Auth.tmp_username
	SilentWolf.Auth.sw_email_verif_complete.connect(_on_confirmation_complete)
	SilentWolf.Auth.sw_resend_conf_code_complete.connect(_on_resend_code_complete)


func _on_confirmation_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		confirmation_success()
	else:
		confirmation_failure(sw_result.error)


func confirmation_success() -> void:
	SWLogger.info("email verification succeeded: " + str(SilentWolf.Auth.logged_in_player))
	# redirect to configured scene (user is logged in after registration)
	var scene_name = SilentWolf.auth_config.redirect_to_scene
	if SilentWolf.Auth.logged_in_player != null:
		transition.fade_out()
		await get_tree().create_timer(stats.transition_time).timeout
		get_tree().change_scene_to_file("res://menus/main_menu.tscn")
	else:
		transition.fade_out()
		await get_tree().create_timer(stats.transition_time).timeout
		get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Login.tscn")


func confirmation_failure(error: String) -> void:
	hide_processing_label()
	SWLogger.info("email verification failed: " + str(error))
	$"FormContainer/ErrorMessage".text = error
	$"FormContainer/ErrorMessage".show()
	

func _on_resend_code_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		resend_code_success()
	else:
		resend_code_failure()


func resend_code_success() -> void:
	SWLogger.info("Code resend succeeded for player: " + str(SilentWolf.Auth.tmp_username))
	$"FormContainer/ErrorMessage".text = "Confirmation code was resent to your email address. Please check your inbox (and your spam)."
	$"FormContainer/ErrorMessage".show()


func resend_code_failure() -> void:
	SWLogger.info("Code resend failed for player: " + str(SilentWolf.Auth.tmp_username))
	$"FormContainer/ErrorMessage".text = "Confirmation code could not be resent"
	$"FormContainer/ErrorMessage".show()


func show_processing_label() -> void:
	$"FormContainer/ProcessingLabel".text = "Processing..."


func hide_processing_label() -> void:
	$"FormContainer/ProcessingLabel".text = ""


func _on_ConfirmButton_pressed() -> void:
	var username = verif_username.text
	var code = $"FormContainer/CodeContainer/VerifCode".text
	SWLogger.debug("Email verification form submitted, code: " + str(code))
	SilentWolf.Auth.verify_email(username, code)
	show_processing_label()


func _on_ResendConfCodeButton_pressed() -> void:
	var username = verif_username.text
	SWLogger.debug("Requesting confirmation code resend")
	SilentWolf.Auth.resend_conf_code(username)
	show_processing_label()

func _on_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Register.tscn")
