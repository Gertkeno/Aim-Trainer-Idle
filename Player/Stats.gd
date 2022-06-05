extends Node

# Hand
var headshotMultiplier: float = 1.1
var fireDelay: float = 1

# Aim bot
var aimSpeed: float = 1
var headshotChance: float = 1
var flickChance: float = 0

# Enemy
var targetWorth: float = 1
var enemySpeed: float = 1
var enemyMaxSpawn: int = 4
var respawnTime: float = 1

# Meta
var playerXP: float = 0 setget set_player_xp
var totalPurchases: int = 0
var playerDosh: float = 0
var discountValue: float = 0

signal xpChanged
func set_player_xp(v: float) -> void:
	playerXP = v
	emit_signal("xpChanged")
