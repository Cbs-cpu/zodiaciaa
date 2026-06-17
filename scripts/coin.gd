extends Area2D

@export var collect_speed: float = 300.0
@export var points_value: int = 10

var _player: Node2D = null
var _is_collecting: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not _is_collecting or _player == null:
		return
	var dir := _player.global_position - global_position
	if dir.length() < 8.0:
		_collect()
	else:
		position += dir.normalized() * collect_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body
		_is_collecting = true

func _collect() -> void:
	GameManager.add_score(points_value)
	queue_free()
