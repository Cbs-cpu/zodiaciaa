extends CharacterBody2D

# ── Variables exportadas ────────────────────────────────────────────────────
@export var speed: float = 80.0
@export var max_hp: int = 1
@export var damage_to_player: int = 1
@export var drop_rate: float = 0.3
@export var heart_rate: float = 0.1

@export var coin_scene: PackedScene
@export var heart_scene: PackedScene

# ── Estado interno ──────────────────────────────────────────────────────────
var current_hp: int
var _player: Node2D = null
var _damage_cooldown: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	current_hp = max_hp
	if has_node("Hitbox"):
		$Hitbox.body_entered.connect(_on_body_entered)
	_find_player()

func _find_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_player = players[0]

# ── Movimiento: perseguir al jugador ───────────────────────────────────────
func _physics_process(_delta: float) -> void:
	if _player == null:
		_find_player()
		_play_animation("idle")
		return

	var dir := (_player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	if sprite and dir.x != 0.0:
		sprite.flip_h = dir.x < 0.0
	_play_animation("walk")

func _play_animation(anim: String) -> void:
	if sprite and sprite.animation != anim \
			and sprite.sprite_frames \
			and sprite.sprite_frames.has_animation(anim):
		sprite.play(anim)

# ── Daño recibido ───────────────────────────────────────────────────────────
func take_damage(damage: int) -> void:
	current_hp -= damage
	if sprite:
		sprite.modulate = Color(2.0, 2.0, 2.0)
		await get_tree().create_timer(0.08).timeout
		sprite.modulate = Color.WHITE
	if current_hp <= 0:
		die()

# ── Muerte ──────────────────────────────────────────────────────────────────
func die() -> void:
	drop_loot()
	queue_free()

func drop_loot() -> void:
	var roll := randf()
	var parent := get_tree().current_scene
	if roll < heart_rate and heart_scene:
		var h := heart_scene.instantiate()
		h.global_position = global_position
		parent.add_child(h)
	elif roll < drop_rate and coin_scene:
		var c := coin_scene.instantiate()
		c.global_position = global_position
		parent.add_child(c)
	GameManager.enemies_defeated += 1
	GameManager.enemy_defeated.emit()
	GameManager.add_score(10)

# ── Colisión con jugador ────────────────────────────────────────────────────
func _on_body_entered(body: Node2D) -> void:
	if _damage_cooldown:
		return
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage_to_player)
		_damage_cooldown = true
		await get_tree().create_timer(0.5).timeout
		_damage_cooldown = false
