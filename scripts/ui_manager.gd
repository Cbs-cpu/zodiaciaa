extends CanvasLayer

@export var color_normal: Color = Color.WHITE
@export var color_danger: Color = Color.RED
@export var color_levelup: Color = Color.YELLOW

@onready var health_label: Label = $VBoxContainer/HealthLabel
@onready var score_label: Label  = $VBoxContainer/ScoreLabel
@onready var level_label: Label  = $VBoxContainer/LevelLabel

func _ready() -> void:
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.level_up.connect(_on_level_up)
	GameManager.game_over_signal.connect(_on_game_over)
	_refresh_all()

func _refresh_all() -> void:
	health_label.text = "Vidas: %d/%d" % [GameManager.player_health, GameManager.max_player_health]
	score_label.text  = "Puntuación: %d" % GameManager.score
	level_label.text  = "Nivel: %d" % GameManager.level

func _on_health_changed(new_health: int) -> void:
	health_label.text = "Vidas: %d/%d" % [new_health, GameManager.max_player_health]
	if new_health <= 1:
		_blink_label(health_label, color_danger, 0.3)
	else:
		health_label.modulate = color_normal

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Puntuación: %d" % new_score

func _on_level_up(new_level: int) -> void:
	level_label.text = "Nivel: %d" % new_level
	_flash_label(level_label, color_levelup, 0.5)

func _on_game_over() -> void:
	health_label.modulate = color_danger

func _flash_label(label: Label, color: Color, duration: float) -> void:
	label.modulate = color
	await get_tree().create_timer(duration).timeout
	label.modulate = color_normal

func _blink_label(label: Label, color: Color, interval: float) -> void:
	label.modulate = color
	await get_tree().create_timer(interval).timeout
	label.modulate = color_normal
	await get_tree().create_timer(interval).timeout
	if GameManager.player_health <= 1:
		_blink_label(label, color, interval)
