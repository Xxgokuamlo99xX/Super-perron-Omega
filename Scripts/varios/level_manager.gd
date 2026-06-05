extends Node

@export var lista_de_spawners: Array[Node]
@export var indice_lvl : int = 1
@export var tp_mark : Marker2D
var spawners_completados: int = 0
var spawner_espera : int 
@onready var tp = preload("res://Escenas/Cosas/teleport.tscn")

func _ready():
	for spawner in lista_de_spawners:
		spawner.quede_seco.connect(_on_spawner_oleadas_terminadas)
		spawner.oleada_fin.connect(_on_spawner_oleada_fin)

func _on_spawner_oleada_fin():
	spawner_espera += 1
	if spawner_espera == lista_de_spawners.size():
		for spawner in lista_de_spawners:
			if not spawner.oleada_delay.is_inside_tree():
				return
			spawner.oleada_delay.start(spawner.delay)
			spawner.oleada_act += 1
		spawner_espera = 0

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
