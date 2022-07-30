extends Node
class_name WeaponsList

const _weapons: Dictionary = {
	"Mosin": "res://weapons/guns/mosin/Mosin.tscn",
}

static func get_weapon(name: String) -> Weapon:
	var weapon = _weapons.get(name)
	return weapon

const _ammunition: Dictionary = {
	"Mosin": "7.62_r"
}

static func get_ammunition(name: String) -> String:
	return _ammunition[name]
