extends CanvasLayer
@onready var otra_vez: Button = $"HBoxContainer/otra vez"
@onready var salir: Button = $HBoxContainer/salir

func _ready() -> void:
	otra_vez.focus_entered.connect(func(): otra_vez.add_theme_stylebox_override("normal", otra_vez.get_theme_stylebox("hover")))
	otra_vez.focus_exited.connect(func(): otra_vez.remove_theme_stylebox_override("normal"))
	
	salir.focus_entered.connect(func(): salir.add_theme_stylebox_override("normal", salir.get_theme_stylebox("hover")))
	salir.focus_exited.connect(func(): salir.remove_theme_stylebox_override("normal"))
	
	hide()

func _on_otra_vez_pressed() -> void:
	cambio_escena.recargar_escena()

func _on_salir_pressed() -> void:
	cambio_escena.cambio_escena_str("res://Escenas/Niveles/Menu Layout.tscn")

func _on_otra_vez_visibility_changed() -> void:
	if otra_vez:
		$"HBoxContainer/otra vez".grab_focus()
