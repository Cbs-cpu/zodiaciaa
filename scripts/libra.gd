extends "res://scripts/enemy_base.gd"

# Balanza: se mantiene a distancia exacta y rota mientras espera
const ORBIT_DIST: float = 110.0
const ORBIT_SPEED: float = 1.5  # radianes por segundo

var _angle: float = 0.0

func _ready() -> void:
	speed = 85.0
	max_hp = 2
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	if _player == null:
		_find_player()
		return
	var dist := global_position.distance_to(_player.global_position)
	var to_player := (_player.global_position - global_position).normalized()

	if abs(dist - ORBIT_DIST) > 15.0:
		# Ajustar distancia
		var sign_val := 1.0 if dist < ORBIT_DIST else -1.0
		velocity = to_player * speed * sign_val
	else:
		# Orbitar alrededor del jugador
		_angle += ORBIT_SPEED * delta
		var orbit_dir := Vector2(cos(_angle), sin(_angle))
		velocity = orbit_dir * speed

	move_and_slide()
	if sprite:
		sprite.rotation += ORBIT_SPEED * delta
