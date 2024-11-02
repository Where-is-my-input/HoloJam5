extends HBoxContainer
@onready var _0: ColorPickerButton = $"0"
@onready var _1: ColorPickerButton = $"1"
@onready var _2: ColorPickerButton = $"2"
@onready var spr: AnimatedSprite2D = $spr
@onready var _3: ColorPickerButton = $"3"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = Global.gameCleared
	_0.color = Global.palette[0]
	_1.color = Global.palette[1]
	_2.color = Global.palette[2]
	_3.color = Global.palette[3]
	setPalette(Global.palette[0], Global.palette[1], Global.palette[2], Global.palette[3])

func setPalette(c0, c1, c2, c3):
	spr.material.set("shader_parameter/newColor1", c0)
	spr.material.set("shader_parameter/newColor2", c1)
	spr.material.set("shader_parameter/newColor3", c2)
	spr.material.set("shader_parameter/newColor4", c3)


func _on__color_changed(color: Color) -> void:
	Global.palette[0] = color
	spr.material.set("shader_parameter/newColor1", Global.palette[0])


func _on_1_color_changed(color: Color) -> void:
	Global.palette[1] = color
	spr.material.set("shader_parameter/newColor2", Global.palette[1])


func _on_2_color_changed(color: Color) -> void:
	Global.palette[2] = color
	spr.material.set("shader_parameter/newColor3", Global.palette[2])


func _on_3_color_changed(color: Color) -> void:
	Global.palette[3] = color
	spr.material.set("shader_parameter/newColor4", Global.palette[3])
