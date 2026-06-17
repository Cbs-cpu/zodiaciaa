extends "res://scripts/enemy_base.gd"

# Peces: se mueve en ondas sinusoidales, esquiva proyectiles
var _time: float = 0.0
const WAVE_AMPLITUDE: float = 60.0
const WAVE_FREQUENCY: float = 3.0

func _ready() -> void:
	speed = 80.0
	max_hp = 2
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	_time += delta
	var base_dir := (_player.global_position - global_position).normalized()
	var perp := Vector2(-base_dir.y, base_dir.x)
	# Movimiento sinusoidal perpendicular a la dirección de persecución
	var wave := sin(_time * WAVE_FREQUENCY) * WAVE_AMPLITUDE * delta
	velocity = base_dir * speed + perp * wave * 10.0
	move_and_slide()
	if sprite and base_dir.x != 0.0:
		sprite.flip_h = base_dir.x < 0.0
	_play_animation("walk")
