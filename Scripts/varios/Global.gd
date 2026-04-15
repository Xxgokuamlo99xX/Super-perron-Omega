extends Node

var condura : int
var puede_mov : bool = true	

func _ready() -> void:
	get_tree().root.get_viewport().set_canvas_cull_mask_bit(10, false)
