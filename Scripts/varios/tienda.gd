extends Node

func _ready() -> void:
	$Dialogo_trigger.empezar_dialogo()
	
func _process(delta: float) -> void:
	$"dinero".text = "Dinero: " + str(Global.dinero) 
