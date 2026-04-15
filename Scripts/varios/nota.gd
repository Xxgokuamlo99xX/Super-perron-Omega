extends Node2D

var mstr_nota : bool = false
@export var titulo : String
@export var texto : String
@onready var titulo_: Label = $CanvasLayer/Control/ColorRect/VBoxContainer/Titulo
@onready var cuerpo_: RichTextLabel = $CanvasLayer/Control/ColorRect/VBoxContainer/Cuerpo


func _ready() -> void:
	titulo_.text = titulo
	cuerpo_.text = texto
	

func interactuar():
	if !mstr_nota:	
		
		$CanvasLayer.show()
		mstr_nota = true
	else:
		$CanvasLayer.hide()
		mstr_nota = false	
	Global.puede_mov = !Global.puede_mov
	
func _on_area_2d_interactuo() -> void:
	interactuar()
