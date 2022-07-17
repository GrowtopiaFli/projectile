extends Node2D

onready var player:Node2D = get_node("Player");
onready var enemies:Node2D = get_node("Enemies");
onready var spawns:Node2D = get_node("Spawns");
onready var bullets:Node2D = get_node("Bullets");
onready var bulletExplosions:Node2D = get_node("BulletExplosions");
onready var particles:Node2D = get_node("ShootParticles");
onready var spawnTimer:Timer = get_node("SpawnTimer");

onready var hud:Node2D = get_node("HUD");
onready var healthbar:Node2D = hud.get_node("Healthbar");
onready var scoreDisplay:Label = hud.get_node("Score");

var rng:RandomNumberGenerator = RandomNumberGenerator.new();
var enemyList:Array = [
	[Color8(255, 112, 143, 255), Assets.getObject("enemies/Enemy1")],
	[Color8(105, 166, 255, 255), Assets.getObject("enemies/Enemy2")]
];
var keyMap:Dictionary = {
	"Left": [0, -1],
	"Right": [0, 1],
	"Up": [1, -1],
	"Down": [1, 1],
	
	"A": [0, -1],
	"D": [0, 1],
	"W": [1, -1],
	"S": [1, 1]
};

func _keyHold(keyName:String):
	if (keyMap.has(keyName)):
		var key:Array = keyMap[keyName];
		player.slide(key[0], key[1]);
	pass;

func _keyRelease(keyName:String):
	if (keyMap.has(keyName)):
		var key:Array = keyMap[keyName];
		player.release(key[0]);
	pass;

func _explode(pos:Vector2):
	var explosion:Node2D = Assets.bulletParticle.instance();
	explosion.position = pos;
	bulletExplosions.add_child(explosion);
	pass;

func shoot():
	SoundHandler.playSound("shoot");
	player.anim.stop();
	player.anim.play("shoot");
	var particle:Node2D = Assets.shootParticle.instance();
	particle.position = player.position;
	particles.add_child(particle);
	var bullet:RigidBody2D = Assets.bulletRes.instance();
	bullet.setRad(Data.playerDirection);
	bullet.position = player.position + (bullet.direction * 72.0);
	bullet.target = "enm";
	bullet.connect("explode", self, "_explode");
	bullets.add_child(bullet);
	pass;

func enemyShoot(pos:Vector2, rot:float, offset:float):
	var bullet:RigidBody2D = Assets.bullet.instance();
	bullet.setRad(rot);
	bullet.position = pos + (bullet.direction * offset);
	bullet.target = "plr";
	bullet.connect("explode", self, "_explode");
	bullets.add_child(bullet);
	pass;

func _mousePress(idx:int, pos:Vector2):
	if (idx == 0):
		shoot();
	pass;

func _addEnemy(idx:int, pos:Vector2):
	var enemy:RigidBody2D = enemyList[idx][1].instance();
	enemy.position = pos;
	if (enemy.has_signal("shoot")):
		enemy.connect("shoot", self, "enemyShoot");
	enemies.add_child(enemy);
	var newTime:float = spawnTimer.wait_time - 0.025;
	if (newTime < 0.75):
		newTime = 0.75;
	spawnTimer.start(newTime);
	pass;

func _spawnEnemy():
	spawnTimer.stop();
	var selectedEnemy:int = rng.randi_range(0, enemyList.size() - 1);
	var enemySpawn:Node2D = Assets.spawnEffect.instance();
	enemySpawn.enemyIdx = selectedEnemy;
	enemySpawn.position = Vector2(rng.randi_range(64, 1856), rng.randi_range(64, 1016));
	enemySpawn.connect("addEnemy", self, "_addEnemy");
	spawns.add_child(enemySpawn);
	enemySpawn.spawnParticles.process_material.color = enemyList[selectedEnemy][0];
	pass;

func _ready():
	rng.randomize();
	InputHandler.connect("keyHold", self, "_keyHold");
	InputHandler.connect("keyRelease", self, "_keyRelease");
	InputHandler.connect("mousePress", self, "_mousePress");
	spawnTimer.connect("timeout", self, "_spawnEnemy");
	
	SoundHandler.clear();
	SoundHandler.playMusic("shoot", -4);
	pass;

func _physics_process(delta):
	pass;

func _process(delta):
	for bullet in bullets.get_children():
		if (!weakref(bullet).get_ref()):
			bullets.remove_child(bullet);
			bullet.queue_free();
	for spawn in spawns.get_children():
		if (!weakref(spawn).get_ref()):
			spawns.remove_child(spawn);
			spawn.queue_free();
	for particle in particles.get_children():
		if (!weakref(particle).get_ref()):
			particles.remove_child(particle);
			particle.queue_free();
	healthbar.setSize(player.health / player.initialHealth);
	scoreDisplay.text = "Score: " + String(Data.score);
	pass;
