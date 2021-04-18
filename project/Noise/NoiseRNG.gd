class_name NoiseRNG
extends Node

const PRIME_1 := 39916801
const PRIME_2 := 151051
const PRIME_3 := 65537

var _seed := 0.0

func _ready()->void:
  var time := OS.get_time()
  var hour:int = time["hour"]
  var minute:int = time["minute"]
  var second:int = time["second"]
  minute *= 100
  hour *= 10000
  var time_as_int := second+minute+hour
  seed(time_as_int)


func seed(value:int)->void:
  _seed = value


func rn(position:int)->int:
 var mixed := position
 mixed *= PRIME_1
 mixed += seed
 mixed ^= mixed
 mixed += PRIME_2
 mixed ^= mixed
 mixed *= PRIME_3
 mixed ^= mixed
 # This is just Mr. Squirrel's function, but with different primes
 return mixed
