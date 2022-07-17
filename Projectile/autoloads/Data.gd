extends Node

var playerDirection:float = 0;
var playerPosition:Vector2 = Vector2.ZERO;

var invulTime:float = 1;
var blinkTime:float = 0.1;
var hitOpacity:int = 100;
var opacityDiff:int = 255 - hitOpacity;

var score:int = 0;

func addScore(n:int):
	score += n;
	if (score > SaveManager.save.highscore):
		SaveManager.save.highscore = score;
		SaveManager.save();
	pass;

func _ready():
	pass;
