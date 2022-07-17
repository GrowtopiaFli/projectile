extends Node

# KEYBOARD LOGIC
signal keyPress(key);
signal keyHold(key);
signal keyRelease(key);

var keys:Array = [];

# MOUSE LOGIC
signal mouseDoublePress(idx, pos);
signal mousePress(idx, pos);
signal mouseHold(idx, pos);
signal mouseRelease(idx, pos);
signal mouseScroll(idx, pos);
signal mouseMove(pos);

var mouseKeys:Array = [false, false, false];
var mousePosition:Vector2 = Vector2.ZERO;

func _ready():
	pass;

func _process(delta):
	for key in keys:
		emit_signal("keyHold", key);
	for i in range(mouseKeys.size()):
		if (mouseKeys[i]):
			emit_signal("mouseHold", i, mousePosition);
	pass;

func _input(evt):
	if (evt is InputEventKey):
		var key:String = OS.get_scancode_string(evt.scancode);
		match (evt.pressed):
			true:
				if (!keys.has(key)):
					emit_signal("keyPress", key);
					keys.append(key);
			false:
				if (keys.has(key)):
					keys.remove(keys.find(key));
				emit_signal("keyRelease", key);
	elif (evt is InputEventMouseButton):
		mousePosition = evt.position;
		var idx:int = evt.button_index - 1;
		if (idx in range(5)):
			if (idx in range(3)):
				mouseKeys[idx] = evt.pressed;
				match (mouseKeys[idx]):
					true:
						if (evt.doubleclick):
							emit_signal("mouseDoublePress", idx, mousePosition);
						emit_signal("mousePress", idx, mousePosition);
					false:
						emit_signal("mouseRelease", idx, mousePosition);
			else:
				idx -= 3;
				emit_signal("mouseScroll", idx, mousePosition);
	elif (evt is InputEventMouseMotion):
		mousePosition = evt.position;
		emit_signal("mouseMove", mousePosition);
