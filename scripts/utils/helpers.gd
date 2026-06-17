extends Node

# Devuelve un nodo aleatorio del grupo, o null si está vacío
static func random_from_group(tree: SceneTree, group: String) -> Node:
	var nodes := tree.get_nodes_in_group(group)
	if nodes.is_empty():
		return null
	return nodes[randi() % nodes.size()]

# Distancia entre dos nodos 2D
static func dist(a: Node2D, b: Node2D) -> float:
	return a.global_position.distance_to(b.global_position)

# Dirección normalizada de a hacia b
static func dir_to(a: Node2D, b: Node2D) -> Vector2:
	return (b.global_position - a.global_position).normalized()

# Posición aleatoria dentro de un rectángulo con margen
static func random_pos_in_rect(origin: Vector2, width: float, height: float, margin: float = 50.0) -> Vector2:
	return Vector2(
		origin.x + randf_range(margin, width  - margin),
		origin.y + randf_range(margin, height - margin)
	)
