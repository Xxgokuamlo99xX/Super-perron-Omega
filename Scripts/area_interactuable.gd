extends Area2D

signal interactuo

func _process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i.is_in_group("jugador"):
			if Input.is_action_just_pressed("interactuar"):
				interactuo.emit()

func _on_body_entered(body: Node2D) -> void:
	$TextureRect.show()

func _on_body_exited(body: Node2D) -> void:
	$TextureRect.hide()
