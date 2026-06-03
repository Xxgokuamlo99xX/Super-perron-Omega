extends Sprite2D

@onready var jugador = get_tree().get_first_node_in_group("jugador")
@export var margen: float = 20.0

func _process(_delta):
	if not jugador or not is_instance_valid(jugador):
		hide()
		return

	var objetivo = _obtener_mas_cercano("enemigo")
	if not objetivo: 
		objetivo = _obtener_mas_cercano("spawner")
	if not objetivo:
		hide()
		return
	var pos_pantalla = objetivo.get_global_transform_with_canvas().origin
	var tamano_pantalla = get_viewport_rect().size

	var en_pantalla = pos_pantalla.x >= 0 and pos_pantalla.x <= tamano_pantalla.x and \
					  pos_pantalla.y >= 0 and pos_pantalla.y <= tamano_pantalla.y
	if en_pantalla:
		hide()
	else:
		show()
		
	var x_limitado = clamp(pos_pantalla.x, margen, tamano_pantalla.x - margen)
	var y_limitado = clamp(pos_pantalla.y, margen, tamano_pantalla.y - margen)
	global_position = Vector2(x_limitado, y_limitado)
	var direccion = (pos_pantalla - global_position).normalized()
	rotation = direccion.angle() 
	
func _obtener_mas_cercano(nombre_grupo: String) -> Node2D:
	var nodos = get_tree().get_nodes_in_group(nombre_grupo)
	if nodos.is_empty():
		return null
	var nodo_mas_cercano: Node2D = null
	var distancia_minima: float = INF
	
	for nodo in nodos:
		if is_instance_valid(nodo): 
			var distancia = jugador.global_position.distance_squared_to(nodo.global_position)
			if distancia < distancia_minima:
				distancia_minima = distancia
				nodo_mas_cercano = nodo
	return nodo_mas_cercano
