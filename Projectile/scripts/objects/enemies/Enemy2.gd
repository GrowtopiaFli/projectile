extends RigidBody2D

signal shoot(pos, rot, offset);

onready var point:Sprite = get_node("Point");
onready var shootTimer:Timer = get_node("ShootTimer");
onready var invulTimer:Timer = get_node("InvulTimer");

var targetAngle:float = 0;

var health:int = 3;
var invul:bool = false;
var ms:float = 0;

func getId() -> String:
	return "enm";

func shoot():
	emit_signal("shoot", position, targetAngle, 96.0);
	pass;

func _finishInvul():
	invul = false;
	pass;

func _ready():
	shootTimer.connect("timeout", self, "shoot");
	invulTimer.connect("timeout", self, "_finishInvul");
	pass;

func hit():
	health -= 1;
	if (health <= 0):
		SoundHandler.playSound("die");
		Data.addScore(75);
		queue_free();
		return;
	SoundHandler.playSound("hit", -2);
	invul = true;
	invulTimer.start(Data.invulTime);
	pass;

func _process(delta):
	targetAngle = position.angle_to_point(Data.playerPosition) + deg2rad(180)
	point.rotation = targetAngle;
	
	if (invul):
		ms += delta;
		var percent:float = ms / Data.blinkTime;
		if (percent > 1.0):
			percent = 1.0 - (percent - 1.0);
		if (ms > Data.blinkTime * 2.0):
			ms = 0;
			percent = 0;
		modulate.a8 = 255 - (Data.opacityDiff * percent);
	else:
		ms = 0;
		modulate.a8 = 255;
	pass;
