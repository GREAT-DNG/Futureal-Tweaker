extends Panel

var save_file = File.new()
var password = ":)"

var settings_file = File.new()

func _ready():
	if !save_file.file_exists("user://../Futureal/settings.json"):
		return
	save_file.open("user://../Futureal/settings.json", File.READ)
	
	var data = parse_json(save_file.get_line())
	
	if data.has("fullscreen"):
		$TabContainer/Settings/FullscreenCheckButton.pressed = data.fullscreen
	if data.has("mute"):
		$TabContainer/Settings/MuteCheckButton.pressed = data.mute
	if data.has("autoreload"):
		$TabContainer/Settings/AutoreloadCheckButton.pressed = data.autoreload
	if data.has("show_actions"):
		$TabContainer/Settings/ShowActionsCheckButton.pressed = data.show_actions
	if data.has("show_trails"):
		$TabContainer/Settings/ShowTrailsCheckButton.pressed = data.show_trails
	
# Saves
func _on_SavesCheckButton_pressed():
	if save_file.file_exists("user://../Futureal/F" + $TabContainer/Saves/LevelNumberLineEdit.text):
		save_file.open_encrypted_with_pass("user://../Futureal/F" + $TabContainer/Saves/LevelNumberLineEdit.text, File.READ, password)
	else:
		$TabContainer/Saves/CheckAcceptDialog.window_title = "Check result [FAILED]"
		$TabContainer/Saves/CheckAcceptDialog.dialog_text = "Incorrect level number"
		$TabContainer/Saves/CheckAcceptDialog.popup()
		return
	
	var data = parse_json(save_file.get_line())
	var incorrect_values = []
	var result = true
	
	if !data.has("health"):
		incorrect_values.append("health")
		result = false
	if !data.has("coins"):
		incorrect_values.append("coins")
		result = false
	if !data.has("guns_collection"):
		incorrect_values.append("guns_collection")
		result = false
	if !data.has("active_gun_number"):
		incorrect_values.append("active_gun_number")
		result = false
		
	if result:
		$TabContainer/Saves/CheckAcceptDialog.window_title = "Check result [OK]"
		$TabContainer/Saves/CheckAcceptDialog.dialog_text = "All save values are correct"
	else:
		$TabContainer/Saves/CheckAcceptDialog.window_title = "Check result [FAILED]"
		$TabContainer/Saves/CheckAcceptDialog.dialog_text = "Incorrect value(s): " + var2str(incorrect_values)
		
	$TabContainer/Saves/CheckAcceptDialog.popup()
	
func _on_SavesFixButton_pressed():
	if save_file.file_exists("user://../Futureal/F" + $TabContainer/Saves/LevelNumberLineEdit.text):
		save_file.open_encrypted_with_pass("user://../Futureal/F" + $TabContainer/Saves/LevelNumberLineEdit.text, File.READ, password)
	else:
		$TabContainer/Saves/FixAcceptDialog.window_title = "Fix result [FAILED]"
		$TabContainer/Saves/FixAcceptDialog.dialog_text = "Incorrect level number"
		$TabContainer/Saves/FixAcceptDialog.popup()
		return
		
	var data = parse_json(save_file.get_line())
	var correct_values = {
		"health": 10,
		"coins": 0,
		"guns_collection": {
			"name": "Desert Eagle",
			"id": 0,
			"power": 0.8,
			"rate": 0.2,
			"reload_time": 1.21,
			"recoil": 5,
			"bullets": 21,
			"loaded_bullets": 7,
			"clip_size": 7,
			"is_reloaded": true,
			"is_automatic": false},
		"active_gun_number": 0}
		
	if data.has("health"):
		correct_values.health = data.health
	if data.has("coins"):
		correct_values.coins = data.coins
	if data.has("guns_collection"):
		correct_values.guns_collection = data.guns_collection
	if data.has("active_gun_number"):
		correct_values.active_gun_number = data.active_gun_number
		
	save_file.open_encrypted_with_pass("user://../Futureal/F" + $TabContainer/Saves/LevelNumberLineEdit.text, File.WRITE, password)
	save_file.store_line(to_json(correct_values))
	save_file.close()
	
	$TabContainer/Saves/FixAcceptDialog.window_title = "Fix result [OK]"
	$TabContainer/Saves/FixAcceptDialog.dialog_text = "Save " + $TabContainer/Saves/LevelNumberLineEdit.text + " fixed"
	$TabContainer/Saves/FixAcceptDialog.popup()
	
# Settings
func _on_SettingsCheckButton_pressed():
	if !settings_file.file_exists("user://../Futureal/settings.json"):
		$TabContainer/Settings/CheckAcceptDialog.window_title = "Check result [FAILED]"
		$TabContainer/Settings/CheckAcceptDialog.dialog_text = "No settings file"
		$TabContainer/Settings/CheckAcceptDialog.popup()
		return
	
	settings_file.open("user://../Futureal/settings.json", File.READ)
	
	var data = parse_json(settings_file.get_line())
	var incorrect_values = []
	var result = true
	
	if !data.has("fullscreen"):
		incorrect_values.append("fullscreen")
		result = false
	if !data.has("mute"):
		incorrect_values.append("mute")
		result = false
	if !data.has("autoreload"):
		incorrect_values.append("autoreload")
		result = false
	if !data.has("show_actions"):
		incorrect_values.append("show_actions")
		result = false
	if !data.has("show_trails"):
		incorrect_values.append("show_trails")
		result = false
		
	if result:
		$TabContainer/Settings/CheckAcceptDialog.window_title = "Check result [OK]"
		$TabContainer/Settings/CheckAcceptDialog.dialog_text = "Settings are correct"
	else:
		$TabContainer/Settings/CheckAcceptDialog.window_title = "Check result [FAILED]"
		$TabContainer/Settings/CheckAcceptDialog.dialog_text = "Incorrect value(s): " + var2str(incorrect_values)
		
	$TabContainer/Settings/CheckAcceptDialog.popup()
	pass
	
func _on_SettingsFixButton_pressed():
	var data = {
		"fullscreen": $TabContainer/Settings/FullscreenCheckButton.pressed,
		"mute": $TabContainer/Settings/MuteCheckButton.pressed,
		"autoreload": $TabContainer/Settings/AutoreloadCheckButton.pressed,
		"show_actions": $TabContainer/Settings/ShowActionsCheckButton.pressed,
		"show_trails": $TabContainer/Settings/ShowTrailsCheckButton.pressed}
		
	settings_file.open("user://../Futureal/settings.json", File.WRITE)
	settings_file.store_line(to_json(data))
	settings_file.close()
	
	$TabContainer/Saves/FixAcceptDialog.window_title = "Fix result [OK]"
	$TabContainer/Saves/FixAcceptDialog.dialog_text = "Settings fixed"
	$TabContainer/Saves/FixAcceptDialog.popup()
	
# Deleting
func _on_DeleteSaveButton_pressed():
	if settings_file.file_exists("user://../Futureal/settings.json"):
		if Directory.new().remove("user://../Futureal/F" + $TabContainer/Deleting/LevelNumberLineEdit.text) == OK:
			$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [OK]"
			$TabContainer/Deleting/AcceptDialog.dialog_text = "Save " + $TabContainer/Deleting/LevelNumberLineEdit.text + " deleted"
			$TabContainer/Deleting/AcceptDialog.popup()
		else:
			$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [FAILED]"
			$TabContainer/Deleting/AcceptDialog.dialog_text = "Failed to delete save " + $TabContainer/Deleting/LevelNumberLineEdit.text
			$TabContainer/Deleting/AcceptDialog.popup()
	else:
		$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [FAILED]"
		$TabContainer/Deleting/AcceptDialog.dialog_text = "No save " + $TabContainer/Deleting/LevelNumberLineEdit.text + " file"
		$TabContainer/Deleting/AcceptDialog.popup()
	
func _on_DeleteSettingsButton_pressed():
	if settings_file.file_exists("user://../Futureal/settings.json"):
		if Directory.new().remove("user://../Futureal/settings.json") == OK:
			$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [OK]"
			$TabContainer/Deleting/AcceptDialog.dialog_text = "Settings deleted"
			$TabContainer/Deleting/AcceptDialog.popup()
		else:
			$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [FAILED]"
			$TabContainer/Deleting/AcceptDialog.dialog_text = "Failed to delete settings"
			$TabContainer/Deleting/AcceptDialog.popup()
	else:
		$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [FAILED]"
		$TabContainer/Deleting/AcceptDialog.dialog_text = "No settings file"
		$TabContainer/Deleting/AcceptDialog.popup()
	
func _on_DeleteLogsButton_pressed():
	var dir = Directory.new()
	dir.open("user://../Futureal/logs")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			dir.remove(file)
	
	dir.list_dir_end()
	
	$TabContainer/Deleting/AcceptDialog.window_title = "Delete result [OK]"
	$TabContainer/Deleting/AcceptDialog.dialog_text = "Logs deleted"
	$TabContainer/Deleting/AcceptDialog.popup()
	
# About
func _on_GameLinkButton_pressed():
	# warning-ignore:return_value_discarded
	OS.shell_open("https://github.com/GREAT-DNG/Futureal")
	
func _on_TweakerLinkButton2_pressed():
	# warning-ignore:return_value_discarded
	OS.shell_open("https://github.com/GREAT-DNG/Futureal-Tweaker")
