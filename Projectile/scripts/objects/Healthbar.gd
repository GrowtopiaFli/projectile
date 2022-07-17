extends Node2D

onready var total:ColorRect = get_node("Total");
onready var left:ColorRect = get_node("Left");
onready var width:float = total.rect_size.x;

func setSize(percent:float):
	left.rect_size.x = width * percent;
	pass;

func _ready():
	pass;
