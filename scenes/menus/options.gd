extends Control

@onready var master_h: HSlider = $masterH
@onready var g_music_h: HSlider = $GMusicH
@onready var sfx_music_h: HSlider = $SFXMusicH
@onready var button: Button = $MarginContainer/VBoxContainer/Button

const BUS_NAMES := ["Master", "SFX", "VA", "BGM"]
const DB_MAX = 6
const DB_MIN = -24
@onready var master: HSlider = $MarginContainer/VBoxContainer/master
@onready var va: HSlider = $MarginContainer/VBoxContainer/va
@onready var bgm: HSlider = $MarginContainer/VBoxContainer/bgm
@onready var sfx: HSlider = $MarginContainer/VBoxContainer/sfx

@onready var masterBus = AudioServer.get_bus_index(BUS_NAMES[0])
@onready var sfxBus = AudioServer.get_bus_index(BUS_NAMES[1])
@onready var vaBus = AudioServer.get_bus_index(BUS_NAMES[2])
@onready var bgmBus = AudioServer.get_bus_index(BUS_NAMES[3])

func _ready() -> void:
	GetBaseVolume()
	button.grab_focus()
	
func GetBaseVolume() -> void:
	master.value = db_to_linear(AudioServer.get_bus_volume_db(masterBus))
	va.value = db_to_linear(AudioServer.get_bus_volume_db(vaBus))
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfxBus))
	bgm.value = db_to_linear(AudioServer.get_bus_volume_db(bgmBus))

func _on_master_h_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterBus, linear_to_db(value))

func _on_va_h_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(vaBus, linear_to_db(value))

func _on_sfx_h_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfxBus, linear_to_db(value))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_bgm_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgmBus, linear_to_db(value))
