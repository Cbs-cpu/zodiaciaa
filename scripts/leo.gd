extends "res://scripts/enemy_base.gd"

# León: rápido y agresivo, carga cuando está cerca
const CHARGE_RANGE: float = 100.0
const CHARGE_SPEED: float = 200.0

func _ready() -> void:
	speed = 110.0
	max_hp = 3
	damage_to_player = 2
	super._ready()

func _physics_process(_delta: float) -> void:
	if _player == null:
		_find_player()
		return
	var dir := (_player.global_position - global_position).normalized()
	var dist := global_position.distance_to(_player.global_position)
	# Carga a mayor velocidad cuando está cerca
	velocity = dir * (CHARGE_SPEED if dist < CHARGE_RANGE else speed)
	move_and_slide()
	if sprite and velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	_play_animation("walk")
