extends Node

var deaths:int = 0
var shrimpsSacrificed:int = 0
var currentStage:int = 1
var maxJumps:int = 2
var maxDashes:int = 1
var install:bool = false
var trident:bool = false
var audio:AudioStreamPlayer
var gameCleared:bool = false

const AUDIO_IN_GAME = preload("res://scenes/audio/audio_in_game.tscn")
const AUDIO_MAIN_MENU = preload("res://scenes/audio/audio_main_menu.tscn")

var palette:Array = [Color(0.204, 0.455, 0.62, 1), Color(0.294, 0.557, 0.682, 1), Color(0.388, 0.816, 0.831, 1), Color(0.522, 0.78, 0.906, 1)]

func _ready():
	#RenderingServer.set_default_clear_color(Color.BLACK)
	#bgm = AUDIO_MAIN_MENU.instantiate()
	add_child(AUDIO_MAIN_MENU.instantiate())
	#process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	#setBGM()

func setBGM(v = false):
	for c in get_children():
		c.queue_free()
	#bgm = AUDIO_MAIN_MENU.instantiate() if v else AUDIO_IN_GAME.instantiate()
	add_child(AUDIO_MAIN_MENU.instantiate() if v else AUDIO_IN_GAME.instantiate())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func reset():
	shrimpsSacrificed = 0
	deaths = 0
	currentStage = 1
	maxJumps = 2
	maxDashes = 0
	install = false
	trident = false
	resetIGT()

var showTimer = false
var timed = false
var time: float = 0.0
var hours: int = 0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _process(delta):
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	hours = floor(time / 60 / 60 / 60)

func resetIGT():
	time = 0.0
	hours = 0
	minutes = 0
	seconds = 0
	msec = 0
