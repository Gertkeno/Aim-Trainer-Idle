extends Node

# Hand
var headshotMultiplier: float = 1.1
var fireDelay: float = 1
var playerDosh: float = 0 setget set_player_dosh

func set_player_dosh(v: float) -> void:
	playerDosh = v
	emit_signal("doshChanged")

# Aim bot
var aimSpeed: float = 1
var headshotChance: float = 1
var flickChance: float = 0

# Enemy
var targetWorth: float = 1
var enemySpeed: float = 1
var enemyMaxSpawn: int = 4
var respawnTime: float = 4

signal doshChanged
