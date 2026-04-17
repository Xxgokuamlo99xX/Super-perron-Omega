extends Node2D

@export var escena_cambio : PackedScene

func _on_area_interaccion_interactuo() -> void:
	cambio_escena.cambio_escena(escena_cambio)
