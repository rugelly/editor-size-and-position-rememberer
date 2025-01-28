@tool
extends EditorPlugin

# i copied this from seoushi's Restore Editor Window Size for godot 3 https://github.com/seoushi/godot-editor-restore-size
# also used khornel's post in https://github.com/godotengine/godot/issues/5114
# thanks folks

#const SAVE_PATH = "user://editor_window_settings.cfg" #this is auto created in appdata/roaming/godot/app_userdata/'project_name'
const SAVE_PATH = "res://editor_window_settings.cfg" # instead id rather have it in project res

func _enter_tree():

	var config_file = ConfigFile.new()
	var error = config_file.load(SAVE_PATH)

	if error != OK:
		print("settings .cfg not found")
		return
	
	var maximized = config_file.get_value("main", "window-maximized")
	var size : Vector2 = config_file.get_value("main", "window-size")
	var position : Vector2 = config_file.get_value("main", "window-position")

	if not maximized:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
	
	DisplayServer.window_set_size(size)
	DisplayServer.window_set_position(position)

func _exit_tree():
	save()

func save():
	var config_file = ConfigFile.new()

	config_file.set_value("main", "window-size", DisplayServer.window_get_size())
	config_file.set_value("main", "window-position", DisplayServer.window_get_position())
	config_file.set_value("main", "window-maximized", DisplayServer.window_get_mode())

	if config_file.save(SAVE_PATH) != OK:
		print("failed to save editor size/position custom settings")