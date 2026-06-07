extends Node

@onready var jugar: Button = $HBoxContainer/jugar
@onready var opc: Button = $HBoxContainer/opc
@onready var salir: Button = $HBoxContainer/salir
@onready var atras: Button = $opciones/atras
@onready var arriba: PhantomCamera2D = $arriba
@onready var abajo: PhantomCamera2D = $abajo


func _ready() -> void:
	jugar.grab_focus()
	jugar.focus_entered.connect(func(): jugar.add_theme_stylebox_override("normal", jugar.get_theme_stylebox("hover")))
	jugar.focus_exited.connect(func(): jugar.remove_theme_stylebox_override("normal"))
	
	opc.focus_entered.connect(func(): opc.add_theme_stylebox_override("normal", opc.get_theme_stylebox("hover")))
	opc.focus_exited.connect(func(): opc.remove_theme_stylebox_override("normal"))
	
	salir.focus_entered.connect(func(): salir.add_theme_stylebox_override("normal", salir.get_theme_stylebox("hover")))
	salir.focus_exited.connect(func(): salir.remove_theme_stylebox_override("normal"))
	
	atras.focus_entered.connect(func(): atras.add_theme_stylebox_override("normal", atras.get_theme_stylebox("hover")))
	atras.focus_exited.connect(func(): atras.remove_theme_stylebox_override("normal"))
	
func _on_jugar_pressed() -> void:
	Global.armas.clear()
	Global.habilidades.clear()
	Global.habilidades.append("sprint")
	Global.dinero = 0
	cambio_escena.cambio_escena_str("res://Escenas/Niveles/Level1_Fruteria.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_opc_pressed() -> void:
	$opciones/atras.grab_focus()
	abajo.priority = 1
	arriba.priority = 0


func _on_button_pressed() -> void:
	opc.grab_focus()
	abajo.priority = 0
	arriba.priority = 1
