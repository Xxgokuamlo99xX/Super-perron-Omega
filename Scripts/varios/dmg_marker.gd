extends Marker2D

@onready var etiqueta = $Label

func mostrar(cantidad: float):
	etiqueta.text = str(cantidad)
	var desvio_x = randf_range(-20.0, 20.0)
	var desvio_y = randf_range(-10.0, 10.0)
	global_position += Vector2(desvio_x, desvio_y)
	var posicion_final = global_position - Vector2(0, 50)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", posicion_final, 0.7)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)

		
	tween.tween_property(self, "modulate:a", 0.0, 0.7)
	tween.chain().tween_callback(queue_free)
