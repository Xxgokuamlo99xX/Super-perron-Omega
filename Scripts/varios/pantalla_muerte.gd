extends CanvasLayer

func _ready() -> void:
	hide()

func _on_otra_vez_pressed() -> void:
	cambio_escena.recargar_escena()
