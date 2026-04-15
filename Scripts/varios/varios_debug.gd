extends Node

var enemigo_scene : PackedScene = preload("res://Escenas/Entidades/enemigo_platilla_debug.tscn")

func spawn_enemy(posicion_deseada):
	var nuevo_enemigo = enemigo_scene.instantiate()
	var jitter = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	nuevo_enemigo.global_position = posicion_deseada + jitter
	add_sibling(nuevo_enemigo)

func _on_button_pressed() -> void:
	spawn_enemy($Button/Marker2D.global_position)
