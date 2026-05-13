extends Node

var condura : int #se me esta acabando esta de aca
var dinero : int
var puede_mov : bool = true	
var moneda = preload("res://Escenas/Cosas/moneda.tscn")

func _ready() -> void:
	get_tree().root.get_viewport().set_canvas_cull_mask_bit(10, false)
