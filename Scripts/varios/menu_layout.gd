extends Node



func _on_jugar_pressed() -> void:
	cambio_escena.cambio_escena_str("res://Escenas/Niveles/Level1_Fruteria.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
