extends RigidBody2D

export(int) var velocity:int = 96;

onready var invulTimer:Timer = get_node("InvulTimer");

onready var anim:AnimationPlayer = get_node("Anim");

var health:int = 3;
var invul:bool = false;
var ms:float = 0;

func getId() -> String:
	return "enm";

func hit():
	health -= 1;
	if (health <= 0):
		SoundHandler.playSound("die");
		Data.addScore(50);
		queue_free();
		return;
	SoundHandler.playSound("hit", -2);
	invul = true;
	invulTimer.start(Data.invulTime);
	pass;

func _finishInvul():
	invul = false;
	pass;

func _collide(body:Node):
	if (body.has_method("getId")):
		var id:String = body.getId();
		if (id == "plr" && !body.get("invul") && body.has_method("hit")):
			body.hit();
	pass;

func _ready():
	invulTimer.connect("timeout", self, "_finishInvul");
	connect("body_entered", self, "_collide");
	anim.play("default");
	pass;

func _physics_process(delta):
	var positionDiff:Vector2 = Data.playerPosition - position;
	var diffSigns:Vector2 = Vector2(sign(positionDiff.x), sign(positionDiff.y));
	var prevSigns:Vector2 = Vector2(sign(position.x), sign(position.y));
	set_linear_velocity(velocity * diffSigns);
	var curSigns:Vector2 = Vector2(sign(position.x), sign(position.y));
	if (curSigns.x != prevSigns.x):
		position.x = 0;
	if (curSigns.y != prevSigns.y):
		position.y = 0;
	pass;

func _process(delta):
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
