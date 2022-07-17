extends Node

func _keyPress(key:String):
	if (key == "F"):
		OS.window_fullscreen = !OS.window_fullscreen;
	pass;

func _ready():
	InputHandler.connect("keyPress", self, "_keyPress");
	pass;
