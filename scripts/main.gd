extends Node2D

@export var camera_follow_speed: float = 5.0

@onready var camera: Camera2D = $Camera2D
@onready var hud: CanvasLayer = $HUD
@onready var pause_overlay: Control = $PauseOverlay  # Label "PAUSED"

var _player: Node2D = null
var _is_paused: bool = false

func _ready() -> void:
	GameManager.reset_game()
	GameManager.game_over_signal.connect(_on_game_over)
	_find_player()
	if pause_overlay:
		pause_overlay.hide()

func _find_player() -> void:
	var list := get_tree().get_nodes_in_group("player")
	if list.size() > 0:
		_player = list[0]

# ── Seguimiento de cámara ───────────────────────────────────────────────────
func _process(delta: float) -> void:
	_update_camera(delta)
	_check_level_complete()

func _update_camera(delta: float) -> void:
	if camera == null or _player == null:
		return
	camera.global_position = camera.global_position.lerp(
		_player.global_position, camera_follow_speed * delta
	)

# ── Pausa ───────────────────────────────────────────────────────────────────
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _is_paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	_is_paused = true
	GameManager.is_paused = true
	get_tree().paused = true
	if pause_overlay:
		pause_overlay.show()

func resume_game() -> void:
	_is_paused = false
	GameManager.is_paused = false
	get_tree().paused = false
	if pause_overlay:
		pause_overlay.hide()

# ── Game Over ───────────────────────────────────────────────────────────────
func _on_game_over() -> void:
	# GameManager recarga la escena automáticamente tras 1 segundo
	pass

# ── Detección de nivel completo ─────────────────────────────────────────────
func _check_level_complete() -> void:
	if get_tree().get_nodes_in_group("enemies").is_empty():
		return
	# Si no quedan enemigos vivos, avanzar nivel
	# (implementación completa con señal en enemy_base al morir)

func _on_all_enemies_defeated() -> void:
	await get_tree().create_timer(2.0).timeout
	GameManager.difficulty_scale = get_node_or_null("/root/GameManager") \
		and GameManager.get("difficulty_scale") + 0.2 or 1.2
	get_tree().reload_current_scene()
