extends RigidBody2D

signal explode(pos);

export(int) var bulletVelocity:int = 768;

var radians:float = 0;
var direction:Vector2 = Vector2.ZERO;
var target:String = "";

func setRad(rad:float):
	radians = rad;
	rotation = radians;
	direction = Vector2(cos(radians), sin(radians));

func destroy():
	SoundHandler.playSound("break", -10);
	emit_signal("explode", position);
	queue_free();

func _collide(body:Node):
	if (body.has_method("getId")):
		var id:String = body.getId();
		if (id == target && !body.get("invul")):
			if (body.has_method("hit")):
				body.hit();
			destroy();
	pass;

func _ready():
	connect("body_entered", self, "_collide");
	pass;

func _physics_process(delta):
	position += direction * bulletVelocity * delta;
	if (position.x < 0 || position.x > 1920 || position.y < 0 || position.y > 1080):
		destroy();
	pass;

func _process(delta):
	pass;
