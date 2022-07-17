extends Node

var savePath:String = "projectile.save";
var save:Dictionary = {
	"version": 1.0,
	"highscore": 0
};

func save():
	var f:File = File.new();
	var err:bool = f.open_compressed("user://" + savePath, File.WRITE, File.COMPRESSION_ZSTD) != OK;
	if (!err):
		var json:String = JSON.print(save);
		f.store_string(json);
		f.close();

func _ready():
	var f:File = File.new();
	var err:bool = f.open_compressed("user://" + savePath, File.READ, File.COMPRESSION_ZSTD) != OK;
	if (!err):
		var res:JSONParseResult = JSON.parse(f.get_as_text());
		f.close();
		if (res.error == OK):
			if (res.result is Dictionary):
				var result:Dictionary = res.result;
				if (result.has("version")):
					if (save.version == result.version):
						for key in save.keys():
							if (result.has(key)):
								save[key] = result[key];
	pass;
