extends Spatial

signal firing

export(NodePath) var inventory_manager

var current_weapons: Array = []
var loaded_weapons: Array = []
var selected_weapon_idx = 0

onready var hand: Spatial  = get_parent()
onready var inventory = get_node(inventory_manager)

func _ready():
#	current_weapons = inventory_manager.get_all_weapons()
	for weapon in current_weapons:
		self.add_child(_load_weapon(weapon), true)
	loaded_weapons.append_array(self.get_children())

func get_primary():
	equip_weapon(0)

func get_secondary():
	equip_weapon(1)

func get_meelee():
	equip_weapon(2)

func fire_weapon():
	if loaded_weapons[selected_weapon_idx].has_method("fire"):
		loaded_weapons[selected_weapon_idx].fire()

func equip_weapon(idx):
	for weapon in loaded_weapons:
		weapon.visible = false
	if loaded_weapons[idx]:
		if !_is_weapon_equipped(idx):
			loaded_weapons[idx].visible = true
			loaded_weapons[idx].equip()
			selected_weapon_idx = idx

func hide_weapon(idx):
	if loaded_weapons[idx].visible:
		loaded_weapons[idx].visible = true
	else:
		loaded_weapons[idx].visible = false

func _is_weapon_equipped(idx) -> bool:
	return loaded_weapons[idx].visible

func _get_weapon_stats(name):
	pass

func _load_weapon(name):
	var res = "res://weapons/%s.tscn" % name
	var weapon = load(res)
	print("weapon %s loaded" % res)
	return weapon.instance()
