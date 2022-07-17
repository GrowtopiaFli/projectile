extends Node

var bullet:Resource = getObject("Bullet");
var bulletParticle:Resource = getObject("BulletParticle");
var shootParticle:Resource = getObject("ShootParticle");
var spawnEffect:Resource = getObject("EnemySpawn");
var bulletRes:Resource = getObject("Bullet");

func getScene(path:String) -> Resource:
	return load("res://scenes/" + path + ".tscn");

func getObject(path:String) -> Resource:
	return getScene("objects/" + path)

func getAudio(path:String) -> AudioStreamOGGVorbis:
	return load("res://assets/audio/" + path + ".ogg") as AudioStreamOGGVorbis;

func _ready():
	pass;
