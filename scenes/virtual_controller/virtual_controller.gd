extends Node
class_name VirtualControllerClass

@onready var tmr_jump: Timer = $tmrJump
@onready var tmr_attack: Timer = $tmrAttack
@onready var tmr_dash: Timer = $tmrDash

var direction:Vector2
var jump:bool
var attack:bool
var dash:bool

var inputBuffer:float = 0.15 #0.06 = 1f?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	#attack = Input.is_action_just_pressed("attack")
	#dash = Input.is_action_just_pressed("ui_cancel")
	#jump = Input.is_action_just_pressed("ui_accept")

	#if !attack && Input.is_action_just_pressed("attack"):
		#attack = true
		#tmr_attack.start(inputBuffer)
	
	attack = actionPressed(attack, tmr_attack, "attack")
	jump = actionPressed(jump, tmr_jump, "ui_accept")
	dash = actionPressed(dash, tmr_dash, "ui_cancel")

func actionPressed(action, timer, actionName):
	if !action && Input.is_action_just_pressed(actionName):
		timer.start(inputBuffer)
		return true
	if !timer.is_stopped(): return true
	return false

func jumped():
	jump = false
	tmr_jump.stop()

func dashed():
	dash = false
	tmr_dash.stop()
