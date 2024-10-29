extends Node

var deaths:int = 0
var shrimpsSacrificed:int = 0
var currentStage:int = 1
var maxJumps:int = 2
var maxDashes:int = 0
var install:bool = false
var trident:bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().change_scene_to_file("res://scenes/debug.tscn")

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
