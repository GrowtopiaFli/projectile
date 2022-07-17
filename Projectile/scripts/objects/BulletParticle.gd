extends Node2D

onready var particle:Particles2D = get_node("Particle");

func _ready():
	particle.emitting = true;
	pass;

func _process(delta):
	if (!particle.emitting):
		particle.queue_free();
		queue_free();
	pass;
