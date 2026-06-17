extends CharacterBody2D

# ── Variables exportadas (ajustables desde el editor) ──────────────────────
@export var speed: float = 150.0
@export var acceleration: float = 500.0
@export var projectile_scene: PackedScene

# ── Nodos internos ──────────────────────────────────────────────────────────
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# ── Estado interno ──────────────────────────────────────────────────────────
var _is_damaged: bool = false

func _ready() -> void:
	add_to_group("player")
	if not sprite:
		push_error("Player: No se encontró AnimatedSprite2D")

# ── Proceso físico: movimiento + animación ──────────────────────────────────
func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_animation()
	move_and_slide()

func _handle_movement(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

func _handle_animation() -> void:
	if not sprite:
		return
	var new_anim := "walk" if velocity.length() > 10.0 else "idle"
	if sprite.animation != new_anim:
		sprite.play(new_anim)
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0

# ── Input: disparo con click izquierdo ─────────────────────────────────────
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_shoot(get_global_mouse_position())

func _shoot(target_pos: Vector2) -> void:
	if projectile_scene == null:
		return
	var proj := projectile_scene.instantiate()
	proj.global_position = global_position
	proj.direction = (target_pos - global_position).normalized()
	get_tree().current_scene.add_child(proj)

# ── Sistema de daño ─────────────────────────────────────────────────────────
func take_damage(damage: int) -> void:
	if _is_damaged:
		return
	GameManager.take_player_damage(damage)
	_flash_damage()

func _flash_damage() -> void:
	_is_damaged = true
	if sprite:
		sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	if sprite:
		sprite.modulate = Color.WHITE
	_is_damaged = false
