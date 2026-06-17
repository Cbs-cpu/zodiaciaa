extends "res://scripts/enemy_base.gd"

# Doncella mágica: se teletransporta aleatoriamente tras atacar
const TELEPORT_DIST: float = 150.0
const TELEPORT_COOLDOWN: float = 3.0

var _teleport_timer: float = 0.0

func _ready() -> void:
	speed = 100.0
	max_hp = 1
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	var dir := (_player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	if sprite and velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	_play_animation("walk")

	_teleport_timer += delta
	if _teleport_timer >= TELEPORT_COOLDOWN:
		_teleport_timer = 0.0
		_teleport()

func _teleport() -> void:
	# Desaparecer brevemente, reaparecer en posición aleatoria cercana
	var angle := randf() * TAU
	var offset := Vector2(cos(angle), sin(angle)) * TELEPORT_DIST
	if sprite:
		sprite.modulate.a = 0.0
	global_position += offset
	await get_tree().create_timer(0.1).timeout
	if sprite:
		sprite.modulate.a = 1.0
