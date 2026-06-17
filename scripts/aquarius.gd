extends "res://scripts/enemy_base.gd"

# Elemental de agua: deja charcos que ralentizan al jugador
@export var puddle_scene: PackedScene
const PUDDLE_INTERVAL: float = 1.2

var _puddle_timer: float = 0.0

func _ready() -> void:
	speed = 75.0
	max_hp = 3
	damage_to_player = 1
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_puddle_timer += delta
	if _puddle_timer >= PUDDLE_INTERVAL:
		_puddle_timer = 0.0
		_leave_puddle()

func _leave_puddle() -> void:
	if puddle_scene == null:
		return
	var p := puddle_scene.instantiate()
	p.global_position = global_position
	get_tree().current_scene.add_child(p)
