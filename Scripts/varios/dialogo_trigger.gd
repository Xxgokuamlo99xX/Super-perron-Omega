extends Node2D

@export var dialogo : DialogicTimeline
var hablando : bool

func empezar_dialogo():
	if !hablando:
		Global.puede_mov = false
		Dialogic.start(dialogo)
		hablando = true
		await Dialogic.timeline_ended  
		await get_tree().create_timer(0.7).timeout
		hablando = false
		Global.puede_mov = true

func _on_area_interaccion_interactuo() -> void:
	empezar_dialogo()
	
