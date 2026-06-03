extends Node

#IDs de armas:
#1: cuchillo
#2: pistola
#3: escopeta
#4: granada

var dinero : int
var dinero_temp : int
var puede_mov : bool = true	
var moneda = preload("res://Escenas/Cosas/moneda.tscn")
var pausa : bool = false
var niveles_comp : Array 
var armas : Array = ["cuchillo","pistola","escopeta"]
var control : bool = false
var arma_act : int = 1

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
			control = true
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			
	elif event is InputEventMouseMotion or event is InputEventMouseButton:
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			control = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#print(control)
func _ready() -> void:
	get_tree().root.get_viewport().set_canvas_cull_mask_bit(10, false)

func comprar(cosa : String):
	armas.append(cosa)
