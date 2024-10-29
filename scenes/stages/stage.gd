extends Node2D

@export var tileMap:TileMapLayer
@export var gura:CharacterBody2D

func _ready() -> void:
	gura.setCameraLimits(tileMap, global_position)
