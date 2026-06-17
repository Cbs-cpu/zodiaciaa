extends "res://scripts/enemy_base.gd"

# Cabra montesa: persecución en zigzag, difícil de esquivar
const ZIG_INTERVAL: float = 0.8

var _zig_timer: float = 0.0
var _zig_offset: float = 0.0

func _ready() -> void:
	speed = 85.0
	max_hp = 3
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	_zig_timer += delta
	if _zig_timer >= ZIG_INTERVAL:
		_zig_timer = 0.0
		_zig_offset = randf_range(-40.0, 40.0)

	var base_dir := (_player.global_position - global_position).normalized()
	var perp := Vector2(-base_dir.y, base_dir.x) * _zig_offset * 0.01
	velocity = (base_dir + perp).normalized() * speed
	move_and_slide()
	if sprite and velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	_play_animation("walk")
