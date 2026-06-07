extends Node

func _ready() -> void:
	$Dialogo_trigger.empezar_dialogo()
	
func _process(delta: float) -> void:
	$"CanvasLayer/dinero".text = ": " + str(Global.dinero) 
