extends "res://scripts/enemy_base.gd"

# Carnero agresivo: rápido, frágil, persecución directa
const CHASE_SPEED: float = 120.0
const CHASE_RANGE: float = 150.0

func _ready() -> void:
	speed = 100.0
	max_hp = 1
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	# Acelera cuando está cerca del jugador
	var dist := global_position.distance_to(_player.global_position)
	velocity = (_player.global_position - global_position).normalized() \
		* (CHASE_SPEED if dist < CHASE_RANGE else speed)
	move_and_slide()
	if sprite and velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	_play_animation("walk")
