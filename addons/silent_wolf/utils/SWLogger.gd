extends Node

const SWUtils = preload("res://addons/silent_wolf/utils/SWUtils.gd")

static func get_log_level():
	var log_level = 1
	if SilentWolf.config.has('log_level'):
		log_level = SilentWolf.config.log_level
	else:
		error("Couldn't find SilentWolf.config.log_level, defaulting to 1") 
	return log_level
	
static func error(text):
	if Stats.dev_mode:
		printerr(str(text))
		push_error(str(text))
	else:
		pass

static func info(text):
	if Stats.dev_mode:
		if get_log_level() > 0:
			print(str(text))
	else:
		pass
	
static func debug(text):
	if Stats.dev_mode:
		return
		if get_log_level() > 1:
			print(str(text))
	else:
		pass

static func log_time(log_text, log_level='INFO'):
	var timestamp = SWUtils.get_timestamp()
	if log_level == 'ERROR':
		error(log_text + ": " + str(timestamp))
	elif log_level == 'INFO':
		info(log_text + ": " + str(timestamp))
	else:
		debug(log_text + ": " + str(timestamp))
