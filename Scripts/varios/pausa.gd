extends CanvasLayer

@onready var jugador = get_tree().get_first_node_in_group("jugador")

func _ready():
	hide()

func _physics_process(delta):
	if Input.is_action_just_pressed("opciones"):
		_pausa()
	#print(GlobalVar.pausa)
	
func _pausa():
	if jugador.vida <= 0:
		return
	if Global.pausa == false:
		show()
		get_tree().paused = true
		
	elif Global.pausa == true:
		hide()
		get_tree().paused = false
		
			
	Global.pausa = !Global.pausa
		
func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif toggled_on == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_button_2_mouse_entered() -> void:
	$botones/salir.text = "Miedo o que"

func _on_button_2_mouse_exited() -> void:
	$botones/salir.text = "Salir"
