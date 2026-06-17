extends "res://scripts/enemy_base.gd"

# Escorpión: deja rastros de veneno que dañan al jugador
@export var poison_scene: PackedScene
const POISON_INTERVAL: float = 0.6

var _poison_timer: float = 0.0

func _ready() -> void:
	speed = 95.0
	max_hp = 2
	damage_to_player = 2
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	# Dejar rastro de veneno mientras se mueve
	if velocity.length() > 5.0:
		_poison_timer += delta
		if _poison_timer >= POISON_INTERVAL:
			_poison_timer = 0.0
			_leave_poison()

func _leave_poison() -> void:
	if poison_scene == null:
		return
	var p := poison_scene.instantiate()
	p.global_position = global_position
	get_tree().current_scene.add_child(p)
