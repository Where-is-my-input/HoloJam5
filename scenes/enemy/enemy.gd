extends CharacterBody2D
@onready var tmr_respawn: Timer = $tmrRespawn

@export var maxHp:int = 1
@export var respawn:float = 3
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var hp

func _ready() -> void:
	hp = maxHp

func getHit():
	hp -= 1
	if hp <= 0:
		Global.shrimpsSacrificed += 1
		spawnState()
		tmr_respawn.start(respawn)

func _on_tmr_respawn_timeout() -> void:
	spawnState(true)

func spawnState(v = false):
	#collision_shape_2d.disabled = v
	collision_shape_2d.set_deferred("disabled", !v)
	visible = v
	hp = maxHp
