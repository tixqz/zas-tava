extends Node
class_name Weapon

export var weaponName: String = ""
export var isMeelee: bool
export var isAuto: bool
export var recoil: float

export(NodePath) var anim_player_path
export(NodePath) var sound_player_path

var anim_player: AnimationPlayer
var sound_player: AudioStreamPlayer3D
var weapon_manager

var maxAmmo: int
var ammo: int
var maxClip: int
var clip: int

var _reloading = false

func _ready():
	weapon_manager = get_parent()
	if !weapon_manager.is_class("WeaponManager"):
		push_error("NOT A WEAPON MANAGER")

	anim_player = get_node(anim_player_path)
	sound_player = get_node(sound_player_path)
	

func fire():
	if not _reloading:
		pass

func hide():
	pass

func equip():
	pass

func reload():
	pass

func get_weapon_info() -> Dictionary:
	return {
		"Name": weaponName,
		"Ammo": ammo,
		"Clip": clip,
		"Auto": isAuto,
	}

func update_info() -> void:
	pass
