extends Node2D

onready var highscoreDisplay:Label = get_node("Highscore");
onready var scoreDisplay:Label = get_node("Score");

func _keyRelease(key:String):
	if (key == "E"):
		SoundHandler.playSound("break");
		get_tree().change_scene_to(Assets.getScene("Menu"));
	pass;

func _ready():
	SoundHandler.clear();
	InputHandler.connect("keyRelease", self, "_keyRelease");
	highscoreDisplay.text += String(SaveManager.save.highscore);
	scoreDisplay.text += String(Data.score);
	Data.score = 0;
	pass;
