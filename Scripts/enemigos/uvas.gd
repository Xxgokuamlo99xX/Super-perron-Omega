extends enemigos

@onready var uvitas = preload("res://Escenas/Entidades/miniuva.tscn")

func morir():
	siguiendo = false
	agent.target_position = global_position
	await get_tree().create_timer(1).timeout
	for i in range(1,4):
		var inst = uvitas.instantiate()
		inst.global_position = global_position
		get_parent().add_child(inst)
	queue_free()
	
	
