extends Node

@export var lista_de_spawners: Array[Node]
@export var indice_lvl : int = 1
@export var tp_mark : Marker2D
var spawners_completados: int = 0
@onready var tp = preload("res://Escenas/Cosas/teleport.tscn")

func _ready():
	for spawner in lista_de_spawners:
		spawner.quede_seco.connect(_on_spawner_oleadas_terminadas)

func _on_spawner_oleadas_terminadas():
	spawners_completados += 1
	if spawners_completados >= lista_de_spawners.size():
		abrir_puerta()

func abrir_puerta():
	Global.dinero += Global.dinero_temp
	Global.niveles_comp.append(indice_lvl)
	var inst = tp.instantiate()
	inst.global_position = tp_mark.global_position
	inst.escena_cambio = load("res://Escenas/Cosas/mapa.tscn")
	add_child(inst)
