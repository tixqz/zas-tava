extends Spatial
class_name WeaponManager

var weapon_in_hand: Weapon
var weapon_in_hand_idx: int

var current_weapons: Dictionary = {
	"Primary": null,
	"Secondary": null,
	"Third": null
}

var current_ammunition: Dictionary = {
	
}

const CURRENT_WEAPON_IDX: Dictionary = {
	0: "Primary",
	1: "Secondary",
	2: "Third"
}

onready var arsenal = get_node("res://weapons/WeaponsList.gd")

func _test_equipment():
	current_weapons.Primary = arsenal.get_weapon("Mosin")

func equip_all_weapons(weaponry: Dictionary):
	pass

func _ready():
	_test_equipment()
	weapon_in_hand_idx = 1
	change_weapon(weapon_in_hand_idx)

func equip_weapon(index, item):
	pass

func get_ammo(item):
	pass

func change_weapon(index):
	if CURRENT_WEAPON_IDX.get(index):
		var _current: Weapon = weapon_in_hand
		_current.hide()
		_current = current_weapons[CURRENT_WEAPON_IDX[index]]
		_current.equip()
		weapon_in_hand = _current
		weapon_in_hand_idx = index

func get_off_weapon():
	remove_child(weapon_in_hand)

func fire():
	weapon_in_hand.fire()

func reload():
	weapon_in_hand.reload()
