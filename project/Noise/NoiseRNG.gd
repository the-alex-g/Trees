class_name NoiseRNG
extends Node

const PRIME_1 := 39916801
const PRIME_2 := 151051
const PRIME_3 := 65537

var _seed := 0.0

func _ready()->void:
	seed_as_time()


func seed_noise(value:int)->void:
	_seed = value


func seed_as_time()->void:
	var time := OS.get_time()
	var hour:int = time["hour"]
	var minute:int = time["minute"]
	var second:int = time["second"]
	minute *= 100
	hour *= 10000
	var time_as_int := second+minute+hour
	seed_noise(time_as_int)


func random(position:int)->int:
	var mixed := position
	mixed *= PRIME_1
	mixed += _seed
	mixed *= mixed
	mixed += PRIME_2
	mixed *= mixed
	mixed *= PRIME_3
	mixed *= mixed
	mixed = abs(mixed)
	# This is just Mr. Squirrel's function, but with different primes
	return mixed
