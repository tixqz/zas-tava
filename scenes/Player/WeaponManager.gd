extends Spatial
class_name WeaponManager

var weapon_in_hand: Weapon
var last_handed_weapon: Weapon
var fast_ammo_type: String

var weapon_in_hand_idx: int
var last_handed_weapon_idx: int

var unarmed = false

var can_shoot = true

var current_weapons: Dictionary = {
	"Primary": null,
	"Secondary": null,
	"Third": null,
}

var current_ammunition: Dictionary = {}

const CURRENT_WEAPON_IDX: Dictionary = {
	0: "Primary",
	1: "Secondary",
	2: "Third",
	3: "Unarmed",
}

onready var camera = get_parent()
onready var player = owner
onready var arsenal = preload("res://weapons/WeaponsList.gd")

#signals

func _test_equipment() -> Dictionary:
	var _weaponry: Dictionary = {}
	_weaponry["Primary"] = "Mosin"
	return _weaponry

func _test_ammunition() -> Dictionary:
	var _ammo: Dictionary = {
		"7.62_r": 20,
		"7.62_ar": 120
	}
	return _ammo

func _ready():
	#connect to signal
	owner.connect("walking", self, "_on_player_walking")
	
	var test_weaponry = _test_equipment()
	var test_ammo = _test_ammunition()
	weapon_in_hand_idx = 0
	equip_weapons_on_level_start(test_weaponry, test_ammo)
	change_weapon(weapon_in_hand_idx)
	
func equip_weapons_on_level_start(weaponry: Dictionary, _init_ammunition: Dictionary):
	for type in weaponry:
		current_weapons[type] = weaponry[type]
		var _added_weapon = load(_get_weapon_from_arsenal(current_weapons[type])).instance()
		self.add_child(_added_weapon, true)
		current_ammunition[_get_ammo_type(current_weapons[type])] = 0
	print(self.get_children())

func take_weapon(index, item):
	pass

func take_ammo(item):
	pass

func change_weapon(index):
	if CURRENT_WEAPON_IDX.get(index):
		var _current: Weapon = weapon_in_hand
		var _next = get_node(current_weapons[CURRENT_WEAPON_IDX[index]])
		if _current != null:
			_current.hide()
			_current.visible = false
		_current = _next
		_current.visible = true
		print(_current.get_weapon_info())
		_current.equip()
		weapon_in_hand = _current
		weapon_in_hand_idx = index
		fast_ammo_type = _get_ammo_type(weapon_in_hand.name)

func disarm():
	var _current: Weapon = weapon_in_hand
	if _current != null:
		last_handed_weapon = _current
		_current.hide()
		_current.visible = false
	else:
		change_weapon(last_handed_weapon)
		last_handed_weapon = null

func throw_weapon():
	remove_child(weapon_in_hand)

func fire():
	if can_shoot:
		#add signal firing for weapons
		current_ammunition[fast_ammo_type] -= 1
		weapon_in_hand.fire()

func sprint():
	pass

func reload():
	if can_shoot:
		#add signal reloading await/yield
		weapon_in_hand.reload()
		var info = weapon_in_hand.get_weapon_info()
		

func _get_weapon_from_arsenal(name: String):
	return arsenal.get_weapon(name)

func _get_ammo_type(name: String):
	return arsenal.get_ammunition(name)

func _on_player_walking():
	print("i'm walking")
	
