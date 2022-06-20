extends Node
class_name WeaponsList

var _weapons: Dictionary = {
	"Mosin": "res://weapons/guns/mosin/Mosin.tscn",
}

func get_weapon(name: String) -> Weapon:
	var weapon = _weapons.get(name)
	return weapon

var _ammunition: Dictionary = {
	"Mosin": {
		"ammo": 50,
		"clip": 5,
	},
}

func get_ammunition(name: String) -> Dictionary:
	return _ammunition[name]
