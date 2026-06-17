extends "res://scripts/enemy_base.gd"

# Gemelos: al morir en fase 1 se transforma en fase 2
var _phase: int = 1

func _ready() -> void:
	speed = 90.0
	max_hp = 2
	damage_to_player = 1
	super._ready()

func take_damage(damage: int) -> void:
	current_hp -= damage
	if sprite:
		sprite.modulate = Color(2.0, 2.0, 2.0)
		await get_tree().create_timer(0.08).timeout
		sprite.modulate = Color.WHITE
	if current_hp <= 0:
		if _phase == 1:
			_transform_to_phase2()
		else:
			die()

func _transform_to_phase2() -> void:
	_phase = 2
	current_hp = 1
	speed = 100.0
	# El sprite de la fase 2 se asigna en el editor o aquí si tiene frames
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("phase2"):
		sprite.play("phase2")
