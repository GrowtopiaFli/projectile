extends RigidBody2D

# Physics Exports
export(int) var slideVelocity:int = 64;
export(int) var maxSlideVelocity:int = 384;
export(int) var slideFriction:int = 8;
export(int) var resetThreshold:int = 8;

onready var bodyNode:Node2D = get_node("Node");
onready var pointer:Node2D = bodyNode.get_node("Pointer");

onready var tip:Sprite = bodyNode.get_node("Tip");
onready var shootEffect:Sprite = bodyNode.get_node("ShootEffect");
onready var particles:Node2D = bodyNode.get_node("ShootParticles");

onready var invulTimer:Timer = get_node("InvulTimer");
onready var regenTimer:Timer = get_node("RegenTimer");

onready var anim:AnimationPlayer = get_node("Anim");

# Movement Variables
var activeAxis:Array = [false, false];
var axisList:Array = ["x", "y"];
var curVelocity:Vector2 = Vector2.ZERO;

var initialHealth:float = 10;
var health:float = 0 + initialHealth;
var invul:bool = false;
var ms:float = 0;

func getId() -> String:
	return "plr";

func _finishInvul():
	invul = false;
	pass;

func _regen():
	health += 1;
	if (health > 10):
		health = 10;
	else:
		SoundHandler.playSound("regen", -6);
	pass;

func _ready():
	InputHandler.connect("mouseMove", self, "_mouseMove");
	invulTimer.connect("timeout", self, "_finishInvul");
	regenTimer.connect("timeout", self, "_regen");
	pass;

func hit():
	SoundHandler.playSound("hit", -2);
	health -= 1;
	if (health <= 0):
		get_tree().change_scene_to(Assets.getScene("GameOver"));
		return;
	invul = true;
	invulTimer.start(Data.invulTime);
	regenTimer.stop();
	regenTimer.start(5);
	pass;

func _mouseMove(pos:Vector2):
	Data.playerDirection = position.angle_to_point(pos) + deg2rad(180);
	pass;

# Movement
func slide(axis:int = 0, data:int = -1):
	if (axis in range(2)):
		activeAxis[axis] = true;
		var axisVel:float = curVelocity[axisList[axis]] + (slideVelocity * data);
		if (abs(axisVel) > maxSlideVelocity):
			axisVel = maxSlideVelocity * sign(axisVel);
		curVelocity[axisList[axis]] = axisVel;
	pass;

func release(axis:int = 0):
	if (axis in range(2)):
		activeAxis[axis] = false;
	pass;

func _physics_process(delta):
#	curVelocity = move_and_slide(curVelocity, Vector2.UP);
	set_linear_velocity(curVelocity);
	for axis in range(activeAxis.size()):
		if (!activeAxis[axis]):
			var axisVel:float = curVelocity[axisList[axis]];
			if (axisVel != 0):
				axisVel -= slideFriction * sign(axisVel);
				if (abs(axisVel) in range(resetThreshold)):
					axisVel = 0;
				curVelocity[axisList[axis]] = axisVel;
	pass;
# End of Movement Logic

func _collide(collider:KinematicCollision2D):
	pass;

func _process(delta):
	Data.playerPosition = position;
	rotation = Data.playerDirection;
	
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
