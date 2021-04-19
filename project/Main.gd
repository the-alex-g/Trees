extends Control

# signals

# enums

# constants
const UNIVERSAL_EVENTS := [
	{"name":"Herbivores", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_h_repel"}, "add":{"variable":"_h_repel", "amount":1}},
	{"name":"Benifical Animal", "add":{"variable":"_h_repel", "amount":1, "reduced_by":"_h_repel"}},
	{"name":"Benifical Animal", "add":{"variable":"_energy_generation", "amount":1, "reduced_by":"_h_repel"}},
	{"name":"Strong Wind", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_wide"}, "add":{"variable":"_wide", "amount":1}},
	{"name":"Disease", "subtract":{"variable":"_energy_generation", "amount":1, "reduced_by":"_d_repel"}, "add":{"variable":"_d_repel", "amount":1}},
]
const DRY_SEASON := [
	{"name":"Herbivores", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_h_repel"}, "add":{"variable":"_h_repel", "amount":1}},
	{"name":"Herbivores", "subtract":{"variable":"_energy", "amount":2, "reduced_by":"_h_repel"}, "add":{"variable":"_h_repel", "amount":1}},
	{"name":"Forest Fire", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_f_repel"}, "add":{"variable":"_f_repel", "amount":1}},
	{"name":"Severe Fire", "subtract":{"variable":"_energy", "amount":2, "reduced_by":"_f_repel"}, "add":{"variable":"_f_repel", "amount":1}},
]
const NORMAL_SEASON := [
	{"name":"Herbivores", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_h_repel"}, "add":{"variable":"_h_repel", "amount":1}},
	{"name":"Forest Fire", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_f_repel"}, "add":{"variable":"_f_repel", "amount":1}},
	{"name":"Lightning Strike", "subtract":{"variable":"_energy", "amount":2}},
	{"name":"Benifical Fungus", "add":{"variable":"_energy_generation", "amount":1, "reduced_by":"_d_repel"}},
	{"name":"Fungal Infestation", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_d_repel"}, "add":{"variable":"_d_repel", "amount":1}},
]
const WET_SEASON := [
	{"name":"Herbivores", "subtract":{"variable":"_energy", "amount":2, "reduced_by":"_h_repel"}, "add":{"variable":"_h_repel", "amount":1}},
	{"name":"Benifical Fungus", "add":{"variable":"_energy_generation", "amount":1, "reduced_by":"_d_repel"}},
	{"name":"Fungal Infestation", "subtract":{"variable":"_energy", "amount":1, "reduced_by":"_d_repel"}, "add":{"variable":"_d_repel", "amount":1}},
	{"name":"Benifical Animal", "add":{"variable":"_h_repel", "amount":1, "reduced_by":"_h_repel"}},
	{"name":"Benifical Animal", "add":{"variable":"_energy_generation", "amount":1, "reduced_by":"_h_repel"}},
	{"name":"Rot", "subtract":{"variable":"_energy_generation", "amount":1}},
	{"name":"Disease", "subtract":{"variable":"_energy_generation", "amount":1, "reduced_by":"_d_repel"}, "add":{"variable":"_d_repel", "amount":1}},
]
const RANDOMIZED_VARIABLES := [
	"_tall",
	"_wide",
	"_thin",
	"_short",
	"_h_repel",
	"_d_repel",
	"_f_repel",
	"_apical_dominance",
	"_fruiting_season",
]
const SEASONS := [
	"Spring",
	"Summer",
	"Autumn"
]

# exported variables
export var event_display_time := 3
export var season_display_time := 1
export var events_per_season := 3
export var energy_requirement := 4
export var difference := 1

# variables

	# variables to be randomized
var _tall := 0
var _wide := 0
var _thin := 0
var _short := 0
var _h_repel := 0
var _d_repel := 0
var _f_repel := 0
var _apical_dominance := 0
var _fruiting_season := 0

	# other variables
var _trunks := 1
var _energy_generation := 6
var _energy := 0
var _starting_values := {
	"_energy_generation":6,
}
var _season_index := 0
var _season_name := ""
var _year_events := []
var _rainfall := 0
var _ignore

# onready variables
onready var _display := $RichTextLabel
onready var _seed := $PlantInterface/Seed
onready var _planting_interface := $PlantInterface
onready var _event_timer := $EventTimer
onready var _season_timer := $SeasonTimer


func _plant()->void:
	for variable in RANDOMIZED_VARIABLES:
		var variable_position := RANDOMIZED_VARIABLES.find(variable)
		var value:int = RNG.random(variable_position)
		value %= 3
		set(variable, value)
		_starting_values[variable] = value
	# check tall and short
	if _tall > _short:
		_tall -= _short
		_short = 0
	elif _tall == _short:
		_short = 0
		_tall = 0
	elif _short > _tall:
		_short -= _tall
		_tall = 0
	# check wide and thin
	if _wide > _thin:
		_wide -= _thin
		_thin = 0
	elif _wide == _thin:
		_thin = 0
		_wide = 0
	elif _thin > _wide:
		_thin -= _wide
		_wide = 0
	_season_index = _fruiting_season
	_get_new_events()
	_advance_season()


func _advance_season()->void:
	var seasons := SEASONS.size()
	_season_name = SEASONS[_season_index%seasons]
	_season_index += 1
	_display.text = _season_name
	if _season_name == "Spring":
		_get_new_events()
	_season_timer.start(season_display_time)
	_consume_energy()


func _get_new_events()->void:
	RNG.seed_as_time()
	_rainfall = RNG.random(12)%3+1
	var events := UNIVERSAL_EVENTS
	match _rainfall:
		1:
			events = _add_events(events, DRY_SEASON)
		2:
			events = _add_events(events, DRY_SEASON)
		3:
			events = _add_events(events, DRY_SEASON)
	_year_events = events


func _consume_energy()->void:
	_energy += _energy_generation#lerp(energy_requirement, _energy_generation, _rainfall/3)
	_energy -= energy_requirement
	if _energy < 0:
		print("DEAD")


func _add_events(current_events:Array, events_to_add:Array)->Array:
	for event in events_to_add:
		current_events.append(event)
	return current_events


func _on_PlantButton_pressed()->void:
	var new_seed:String = _seed.text
	if new_seed != "":
		var new_seed_as_int := int(new_seed)
		RNG.seed_noise(new_seed_as_int)
		_planting_interface.hide()
		_plant()


func _on_SeasonTimer_timeout()->void:
	_display.text = ""
	var events = events_per_season - randi()%3
	for _e in range(0, events):
		_get_event()
	_event_timer.start(event_display_time)


func _get_event()->void:
	var total_events := _year_events.size()
	var event_index = RNG.random(randi())%total_events
	var event:Dictionary = _year_events[event_index]
	_parse_event(event)
	_h_repel -= 1
	_d_repel -= 1
	_f_repel -= 1


func _parse_event(event:Dictionary)->void:
	if event.has("add"):
		var addition_instructions:Dictionary = event["add"]
		var variable_to_add:String = addition_instructions["variable"]
		var reduction := 0
		if event.has("reduced_by"):
			reduction = addition_instructions["reduced_by"]
		var value:int = addition_instructions["amount"]
		value -= reduction
		var current_value = get(variable_to_add)
		var new_value = current_value + value
		var starting_value = _starting_values[variable_to_add]
		if new_value <= starting_value + difference:
			set(variable_to_add, new_value)
			print(variable_to_add+": "+str(new_value))
	
	if event.has("subtract"):
		var subtraction_instructions:Dictionary = event["subtract"]
		var variable_to_subtract:String = subtraction_instructions["variable"]
		var reduction := 0
		if event.has("reduced_by"):
			reduction = subtraction_instructions["reduced_by"]
		var value:int = subtraction_instructions["amount"]
		value -= reduction
		var current_value = get(variable_to_subtract)
		set(variable_to_subtract, current_value - value)
	
	var event_name:String = event["name"]
	_display.text += event_name + "\n"


func _on_EventTimer_timeout()->void:
	_display.text = ""
	_advance_season()
