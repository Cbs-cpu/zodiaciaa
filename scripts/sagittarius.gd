extends "res://scripts/enemy_base.gd"

# Arquero: dispara proyectiles desde lejos, huye del cuerpo a cuerpo
@export var projectile_scene: PackedScene
const SHOOT_RANGE: float = 200.0
const FLEE_RANGE: float = 80.0
const SHOOT_COOLDOWN: float = 2.0

var _shoot_timer: float = 0.0

func _ready() -> void:
	speed = 90.0
	max_hp = 2
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	var dist := global_position.distance_to(_player.global_position)
	var dir := (_player.global_position - global_position).normalized()

	if dist < FLEE_RANGE:
		velocity = -dir * speed  # huir
	elif dist > SHOOT_RANGE:
		velocity = dir * speed   # acercarse
	else:
		velocity = Vector2.ZERO  # posición de disparo

	move_and_slide()
	if sprite and dir.x != 0.0:
		sprite.flip_h = dir.x < 0.0
	_play_animation("walk" if velocity.length() > 5.0 else "idle")

	_shoot_timer += delta
	if _shoot_timer >= SHOOT_COOLDOWN and dist <= SHOOT_RANGE:
		_shoot_timer = 0.0
		_shoot(dir)

func _shoot(dir: Vector2) -> void:
	if projectile_scene == null:
		return
	var proj := projectile_scene.instantiate()
	proj.global_position = global_position
	proj.direction = dir
	get_tree().current_scene.add_child(proj)
