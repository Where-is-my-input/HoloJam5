extends Control
@onready var lbl_deaths: Label = $lblDeaths
@onready var lbl_shrimps: Label = $lblShrimps
@onready var label: Label = $Label
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.grab_focus()
	var time = "%02d:" % Global.hours
	time += "%02d:" % Global.minutes
	time += "%02d." % Global.seconds
	time += "%03d" % Global.msec
	label.text = str(time)
	lbl_deaths.text = str(Global.deaths)
	lbl_shrimps.text = str(Global.shrimpsSacrificed)
	Global.gameCleared = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
