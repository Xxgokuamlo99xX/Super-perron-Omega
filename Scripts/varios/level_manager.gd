extends Node

@export var lista_de_spawners: Array[Node]
var spawners_completados: int = 0

func _ready():
	for spawner in lista_de_spawners:
		spawner.quede_seco.connect(_on_spawner_oleadas_terminadas)

func _on_spawner_oleadas_terminadas():
	spawners_completados += 1
	if spawners_completados >= lista_de_spawners.size():
		abrir_puerta()

func abrir_puerta():
	pass
