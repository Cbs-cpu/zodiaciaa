extends "res://scripts/enemy_base.gd"

# Cangrejo: se mantiene a distancia, retrocede si el jugador se acerca
const PREFERRED_DIST: float = 120.0

func _ready() -> void:
	speed = 70.0
	max_hp = 2
	damage_to_player = 1
	super._ready()

func _physics_process(_delta: float) -> void:
	if _player == null:
		_find_player()
		return
	var to_player := _player.global_position - global_position
	var dist := to_player.length()
	if dist < PREFERRED_DIST:
		# Retroceder
		velocity = -to_player.normalized() * speed
	elif dist > PREFERRED_DIST + 20.0:
		# Acercarse hasta la distancia preferida
		velocity = to_player.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if sprite and velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	_play_animation("walk" if velocity.length() > 5.0 else "idle")
