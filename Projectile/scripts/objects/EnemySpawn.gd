extends Node2D

signal addEnemy(idx, pos);

onready var spawnParticles:Particles2D = get_node("SpawnParticles");
onready var spawnTimer:Timer = get_node("SpawnTimer");

var enemyIdx:int = 0;

func _spawnTimeout():
	emit_signal("addEnemy", enemyIdx, position);
	spawnTimer.queue_free();
	spawnParticles.queue_free();
	queue_free();
	pass;

func _ready():
	spawnTimer.connect("timeout", self, "_spawnTimeout");
	pass;

func _process(delta):
	pass;
