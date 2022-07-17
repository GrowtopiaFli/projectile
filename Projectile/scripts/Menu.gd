extends Node2D

onready var playBtn:Button = get_node("Play");
onready var exitBtn:Button = get_node("Exit");
onready var highscoreDisplay:Label = get_node("Highscore");

func _play():
	SoundHandler.playSound("break");
	get_tree().change_scene_to(Assets.getScene("Game"));
	pass;

func _exit():
	SoundHandler.playSound("break");
	get_tree().quit();
	pass;

func _ready():
	SoundHandler.clear();
	playBtn.connect("button_up", self, "_play");
	exitBtn.connect("button_up", self, "_exit");
	highscoreDisplay.text += String(SaveManager.save.highscore);
	SoundHandler.playMusic("beware");
	pass;
