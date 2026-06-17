extends "res://scripts/enemy_base.gd"

# Toro tanque: lento, resistente, ataque telegráfico
const ATTACK_RANGE: float = 80.0
const ATTACK_COOLDOWN: float = 3.0

var _attack_timer: float = 0.0

func _ready() -> void:
	speed = 60.0
	max_hp = 5
	damage_to_player = 2
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	var dist := global_position.distance_to(_player.global_position)
	velocity = (_player.global_position - global_position).normalized() * speed
	move_and_slide()
	if sprite and velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	_play_animation("walk")

	# Telegrafiar ataque cada ATTACK_COOLDOWN segundos si está cerca
	_attack_timer += delta
	if _attack_timer >= ATTACK_COOLDOWN and dist <= ATTACK_RANGE:
		_attack_timer = 0.0
		_do_special_attack()

func _do_special_attack() -> void:
	# Flash rojo como advertencia visual antes del golpe
	if sprite:
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.2).timeout
		sprite.modulate = Color.WHITE
