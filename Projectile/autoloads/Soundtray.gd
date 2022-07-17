extends Node2D

onready var layer:CanvasLayer = get_node("Layer");
onready var barsRoot:Node2D = layer.get_node("Bars");
onready var bars:Array = [
	barsRoot.get_node("1"),
	barsRoot.get_node("2"),
	barsRoot.get_node("3"),
	barsRoot.get_node("4"),
	barsRoot.get_node("5"),
	barsRoot.get_node("6"),
	barsRoot.get_node("7"),
	barsRoot.get_node("8"),
	barsRoot.get_node("9"),
	barsRoot.get_node("10")
];
onready var hideTimer:Timer = get_node("HideTimer");

var volume:int = 10;

var keybinds:Array = ["Minus", "Equal"];

func updateBars():
	for i in range(bars.size()):
		var bar:ColorRect = bars[i];
		if (!(i in range(volume))):
			bar.modulate.a8 = 128;
		else:
			bar.modulate.a8 = 255;
	pass;

func _hide():
	layer.layer = -128;
	pass;

func _keyRelease(keyName:String):
	var key:int = keybinds.find(keyName);
	if (key >= 0):
		layer.layer = 128;
		match (key):
			0:
				volume -= 1;
			1:
				volume += 1;
		if (volume < 0):
			volume = 0;
		if (volume > 10):
			volume = 10;
		updateBars();
		var db:int = 0 - (32.0 * (1.0 - (volume / 10.0)));
		if (volume <= 0):
			db = -80;
		AudioServer.set_bus_volume_db(0, db);
		SoundHandler.playSound("beep");
		hideTimer.stop();
		hideTimer.start(2);
	pass;

func _ready():
	hideTimer.connect("timeout", self, "_hide");
	InputHandler.connect("keyRelease", self, "_keyRelease");
	pass;
