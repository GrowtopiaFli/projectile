extends Node2D

onready var music:Node2D = get_node("Music");
onready var sfx:Node2D = get_node("SFX");
onready var gcTimer:Timer = get_node("GCTimer");

func _gc():
	for sound in sfx.get_children():
		if (sound is AudioStreamPlayer):
			if (!sound.playing):
				sfx.remove_child(sound);
				sound.queue_free();
	pass;

func clear():
	for song in music.get_children():
		if (song is AudioStreamPlayer):
			music.remove_child(song);
			song.queue_free();
	pass;

func _ready():
	gcTimer.connect("timeout", self, "_gc");
	pass;

func playMusic(mus:String, db:int = 0):
	var audio:AudioStreamOGGVorbis = Assets.getAudio("music/" + mus);
	var audioPlayer:AudioStreamPlayer = AudioStreamPlayer.new();
	audio.loop = true;
	audioPlayer.stream = audio;
	audioPlayer.volume_db = db;
	audioPlayer.play();
	music.add_child(audioPlayer);
	pass;

func playSound(snd:String, db:int = 0):
	var sound:AudioStreamOGGVorbis = Assets.getAudio("sfx/" + snd);
	var soundPlayer:AudioStreamPlayer = AudioStreamPlayer.new();
	sound.loop = false;
	soundPlayer.stream = sound;
	soundPlayer.volume_db = db;
	soundPlayer.play();
	sfx.add_child(soundPlayer);
	pass;
