extends Node

# ── Señales ─────────────────────────────────────────────────────────────────
signal health_changed(new_health: int)
signal score_changed(new_score: int)
signal level_up(new_level: int)
signal game_over_signal
signal enemy_defeated

# ── Estado global ───────────────────────────────────────────────────────────
var score: int = 0
var level: int = 1
var enemies_defeated: int = 0
var player_health: int = 3
var max_player_health: int = 3
var is_game_over: bool = false
var is_paused: bool = false

func add_score(points: int) -> void:
	var prev := score
	score += points
	score_changed.emit(score)
	if score / 1000 > prev / 1000:
		_level_up_game()

func take_player_damage(damage: int = 1) -> void:
	if is_game_over:
		return
	player_health = max(0, player_health - damage)
	health_changed.emit(player_health)
	if player_health <= 0:
		game_over()

func heal_player(amount: int = 1) -> void:
	player_health = min(max_player_health, player_health + amount)
	health_changed.emit(player_health)

func _level_up_game() -> void:
	level += 1
	level_up.emit(level)
	print("¡Nivel %d!" % level)

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	game_over_signal.emit()
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

func reset_game() -> void:
	score = 0
	level = 1
	enemies_defeated = 0
	player_health = max_player_health
	is_game_over = false
	is_paused = false
	score_changed.emit(score)
	health_changed.emit(player_health)
