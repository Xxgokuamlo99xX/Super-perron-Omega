extends CanvasLayer

func _ready() -> void:
	empezar()

func empezar():
	if Global.armas.has("cuchillo") or Global.armas.has("pistola"):
		return
	await get_tree().create_timer(0.5).timeout
	show()
	get_tree().paused = true
	
func _on_cuchillo_pressed() -> void:
	Global.armas.append("cuchillo")
	Global.arma_act = 1
	get_tree().paused = false
	hide()

	
func _on_pistola_pressed() -> void:
	Global.armas.append("pistola")
	Global.arma_act = 2
	get_tree().paused = false
	hide()
