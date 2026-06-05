extends Area2D

@export var enemigo: CharacterBody2D

func _process(delta: float) -> void:
	if !monitoring:
		return
	for area in get_overlapping_areas():
		if area.is_in_group("jugador_hurtbox"):
			if enemigo:
				area.get_parent().emit_signal("jugador_hit",enemigo.damage)
			
