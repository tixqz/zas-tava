extends Node
class_name Weapon

export var weaponName: String = ""
export var isMeelee: bool
export var isAuto: bool
export var recoil: float
export var isRepeating: bool

export(NodePath) var anim_player_path
export(NodePath) var sound_player_path
export(NodePath) var fire_position_path

var anim_player: AnimationPlayer
var sound_player: AudioStreamPlayer3D
var fire_position: Position3D
var weapon_manager

# Current ammo in clip
var ammo: int
# Maximum ammo in clip
var clip: int

var _reloading = false
var _can_shoot = true
var _car_reload = true

func _ready():
	weapon_manager = get_parent()
	if !weapon_manager.is_class("WeaponManager"):
		push_error("NOT A WEAPON MANAGER")

	anim_player = get_node(anim_player_path)
	sound_player = get_node(sound_player_path)
	fire_position = get_node(fire_position_path)
	

func fire():
	if not _reloading or not _can_shoot:
		if anim_player.has_animation("shoot"):
			anim_player.play("shoot")
			if anim_player.is_playing():
				_can_shoot = false
				# add bullet instancing
				ammo -= 1
			# add handling for repeating if repeating play animation else yield timer
			yield(get_tree().create_timer(recoil), "timeout")
			

func sprint():
	if anim_player.has_animation("sprint"):
		_can_shoot = false
		anim_player.play("sprint")
		if not anim_player.is_playing():
			_can_shoot = true

func hide():
	if anim_player.has_animation("hide"):
		_can_shoot = false
		anim_player.play("hide")
		if not anim_player.is_playing():
			_can_shoot = true

func equip():
	if anim_player.has_animation("equip"):
		_can_shoot = false
		anim_player.play("equip")
		if not anim_player.is_playing():
			_can_shoot = true

func reload():
	_reloading = true
	if anim_player.has_animation("reload"):
		anim_player.play("reload")
		if not anim_player.is_playing():
			_reloading = false
			ammo = clip
	else:
		push_error("WEAPON DOES NOT CONTAIN RELOAD ANIMATION")

func get_weapon_info() -> Dictionary:
	return {
		"Name": weaponName,
		"Ammo": ammo,
		"Clip": clip,
		"Auto": isAuto,
	}

func update_info() -> void:
	pass
