extends Control

var scene

var gameOver:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#match Global.currentStage:
		#1:
			#scene = "res://scenes/stages/stage_1.tscn"
		#2:
			#scene = "res://scenes/stages/stage_2.tscn"
		#3:
			#scene = "res://scenes/stages/stage_3.tscn"
		#_:
			#Global.currentStage = 0
			#scene = "res://scenes/debug.tscn"
	scene = "res://scenes/stages/stage_" + str(Global.currentStage) + ".tscn"
	ResourceLoader.load_threaded_request(scene, "", true)

func _process(delta):
	#if tmr_wait.is_stopped():
	match ResourceLoader.load_threaded_get_status(scene):
		0,1:
			pass
		2:
			if !gameOver: gameOverSequence()
		3:
			var loadedResource = ResourceLoader.load_threaded_get(scene)
			get_tree().change_scene_to_packed(loadedResource)
	#sprite_2d.rotate(365)

func gameOverSequence():
	gameOver = true
	scene = "res://scenes/menus/game_over.tscn"
	ResourceLoader.load_threaded_request(scene, "", true)
