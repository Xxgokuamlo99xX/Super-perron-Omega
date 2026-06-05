extends enemigos

func _ready() -> void:
	siguiendo = false
	

func _on_expiracion_timeout() -> void:
	$anim_aparecer.play_backwards("aparecer")
	await $anim_aparecer.animation_finished
	queue_free()
