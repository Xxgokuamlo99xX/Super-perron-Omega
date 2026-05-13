extends Area2D

var vel : int = 50
@export var valor : int = 1
@onready var jugador = get_tree().get_first_node_in_group("jugador")
var esta_saltando: bool = true

func _ready():
	lanzar_moneda()

func _process(delta) -> void:
	if not esta_saltando and jugador:
		var direccion = global_position.direction_to(jugador.global_position)
		global_position += direccion * vel * delta
		vel += 10

func lanzar_moneda():
	var direccion_aleatoria = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var distancia_salto = randf_range(20, 40)
	var punto_destino = global_position + (direccion_aleatoria * distancia_salto)
	var tween = create_tween()
	tween.tween_property(self, "global_position", punto_destino, 0.5)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): esta_saltando = false)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("jugador"):
		Global.dinero += valor
		queue_free()
