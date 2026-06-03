extends Projectile2D
@onready var hitbox: Area2D = $hitbox_atq_jugador

	
func explotar():
	$Sprite2D.hide()
	hitbox.monitorable = true
	hitbox.monitoring = true
	$AnimationPlayer.play("explotar")
	await$AnimationPlayer.animation_finished
	queue_free()

func _on_fuse_timeout() -> void:
	explotar()

func aplicar_atq(damage : float):
	return

func _on_body_entered(body: Node2D) -> void:
	alto = true
	return
