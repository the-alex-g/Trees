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
]

# exported variables

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

# other variables
var _trunks := 0
var _energy_generation := 0
var _energy := 0
var _damage := 0
var _ignore

# onready variables
onready var _display := $RichTextLabel
onready var _seed := $PlantInterface/Seed
onready var _planting_interface := $PlantInterface


func _plant()->void:
	for variable in RANDOMIZED_VARIABLES:
		var variable_position := RANDOMIZED_VARIABLES.find(variable)
		var value:int = RNG.random(variable_position)
		value %= 4
		set(variable, value)


func _on_PlantButton_pressed():
	var new_seed:String = _seed.text
	if new_seed != "":
		var new_seed_as_int := int(new_seed)
		RNG.seed_noise(new_seed_as_int)
		_planting_interface.hide()
		_plant()
