extends Node2D

func _process(delta: float) -> void:
	$"ColorRect/dinero".text = "Dinero: " + str(Global.dinero) 


func _on_congeladores_pressed() -> void:
	cambio_escena.cambio_escena_str("")

func _on_cocina_pressed() -> void:
	cambio_escena.cambio_escena_str("")

func _on_embutidos_pressed() -> void:
	cambio_escena.cambio_escena_str("")

func _on_botanas_pressed() -> void:
	cambio_escena.cambio_escena_str("")

func _on_cajas_pressed() -> void:
	cambio_escena.cambio_escena_str("")

func _on_tiendas_pressed() -> void:
	cambio_escena.cambio_escena_str("")
