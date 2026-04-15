extends Area2D
@onready var jugador = get_tree().get_first_node_in_group("jugador")
@export_enum("melee","distancia")
var tipo_de_damage : String = "melee"
var enemigos_golpeados : Array
	
func _process(delta: float) -> void:
	match tipo_de_damage:
		"melee":
			if jugador.atacando:
				aplicar_atq(jugador.melee_damage)
		"distancia":
			aplicar_atq(jugador.range_damage)
			
func aplicar_atq(damage : float):
	for area in get_overlapping_areas():
		if area.is_in_group("enemigo"):
			if enemigos_golpeados.has(area):
				return
			area.get_parent().emit_signal("enemigo_hit",damage)
			enemigos_golpeados.append(area)
			#print("toque enemigo")
	
