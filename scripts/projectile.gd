extends Area2D

@export var speed: float = 300.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent and parent.has_method("take_damage"):
		parent.take_damage(damage)
	queue_free()
