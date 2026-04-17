extends CanvasLayer

func cambio_escena(escena : PackedScene) -> void:
	$AnimationPlayer.play("irse")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(escena)
	$AnimationPlayer.play_backwards("irse")
	Global.puede_mov = true
	
func recargar_escena():
	$AnimationPlayer.play("irse")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("irse")
	get_tree().reload_current_scene()
