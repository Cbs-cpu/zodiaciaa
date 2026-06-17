extends Node2D

@export var room_width: int = 320
@export var room_height: int = 180
@export var grid_cols: int = 3
@export var grid_rows: int = 3
@export var difficulty_scale: float = 1.0
@export var enemy_scenes: Array[PackedScene] = []

var _loaded_enemies: Array[PackedScene] = []

func _ready() -> void:
	load_enemy_types()
	generate_level()

func load_enemy_types() -> void:
	_loaded_enemies = enemy_scenes.filter(func(s): return s != null)
	if _loaded_enemies.is_empty():
		var paths := [
			"res://scenes/enemies/aries.tscn",
			"res://scenes/enemies/taurus.tscn",
			"res://scenes/enemies/gemini.tscn",
			"res://scenes/enemies/cancer.tscn",
			"res://scenes/enemies/leo.tscn",
		]
		for p in paths:
			if ResourceLoader.exists(p):
				_loaded_enemies.append(load(p))

func generate_level() -> void:
	for row in grid_rows:
		for col in grid_cols:
			create_room(Vector2(col * room_width, row * room_height), Vector2i(col, row))

func create_room(pos: Vector2, grid_pos: Vector2i) -> void:
	var room := Node2D.new()
	room.name = "Room_%d_%d" % [grid_pos.x, grid_pos.y]
	room.position = pos
	add_child(room)
	create_walls(room)
	var count := randi_range(1, int(4 * difficulty_scale))
	for _i in count:
		spawn_enemy_in_room(room, pos)

func create_walls(room: Node2D) -> void:
	var w := float(room_width)
	var h := float(room_height)
	var defs := [
		[Vector2(w * 0.5, 0),   Vector2(w, 8)],
		[Vector2(w * 0.5, h),   Vector2(w, 8)],
		[Vector2(0,   h * 0.5), Vector2(8, h)],
		[Vector2(w,   h * 0.5), Vector2(8, h)],
	]
	for d in defs:
		var wall := StaticBody2D.new()
		wall.position = d[0]
		var col := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = d[1]
		col.shape = shape
		wall.add_child(col)
		room.add_child(wall)

func spawn_enemy_in_room(room: Node2D, room_world_pos: Vector2) -> void:
	if _loaded_enemies.is_empty():
		return
	var scene: PackedScene = _loaded_enemies[randi() % _loaded_enemies.size()]
	var enemy := scene.instantiate()
	var margin := 50
	enemy.global_position = Vector2(
		room_world_pos.x + randf_range(margin, room_width  - margin),
		room_world_pos.y + randf_range(margin, room_height - margin)
	)
	room.add_child(enemy)
