extends Node2D
@onready var congeladores: Button = $ColorRect/congeladores
@onready var cocina: Button = $ColorRect/cocina
@onready var embutidos: Button = $ColorRect/embutidos
@onready var botanas: Button = $ColorRect/botanas
@onready var cajas: Button = $ColorRect/cajas
@onready var tiendas: Button = $ColorRect/tiendas

func _process(delta: float) -> void:
	$"ColorRect/dinero".text = "Dinero: " + str(Global.dinero) 

	if Global.niveles_comp.has(2):
		congeladores.disabled = true
		
	if Global.niveles_comp.has(3):
		cocina.disabled = true
		
	if Global.niveles_comp.has(4):
		embutidos.disabled = true
		
	if Global.niveles_comp.has(5):
		botanas.disabled = true
		
	if Global.niveles_comp.has(6):
		cajas.disabled = true


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
