extends Node

var targetWorth: float = 1
var headshotMultiplier: float = 1.1
var fireDelay: float = 1 setget ,get_fire_delay

func get_fire_delay() -> float:
	return 1 / fireDelay

var playerDosh: float = 0
