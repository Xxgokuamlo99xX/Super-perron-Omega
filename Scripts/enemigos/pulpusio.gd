extends enemigos

@onready var marca_atq: Marker2D = $Marca_atq
@onready var advertencia: Sprite2D = $Marca_atq/Sprite2D
@onready var atq_cooldown: Timer = $atq_cooldown
@onready var atq_advertencia: Timer = $atq_advertencia
@export var distancia_por_delante = 60.0
var direccion_actual = Vector2.RIGHT 
@onready var tentaculo = preload("res://Escenas/Entidades/tentaculo.tscn")

func _process(delta):
	if jugador == null:
		return
	var input_dir = Input.get_vector("izq", "der", "arriba", "abajo")
	if input_dir.length() > 0.1:
		direccion_actual = input_dir.normalized()
	var posicion_objetivo = jugador.global_position + (direccion_actual * distancia_por_delante)
	marca_atq.global_position = marca_atq.global_position.lerp(posicion_objetivo, 10.0 * delta)
	
func _ready() -> void:
	vida = vida_max
	siguiendo = false
	
func ataque():
	var inst = tentaculo.instantiate()
	inst.global_position = marca_atq.global_position
	inst.damage = damage
	add_sibling(inst)
	
func _on_atq_cooldown_timeout() -> void:
	print("a")
	atq_advertencia.start()
	advertencia.show()

func _on_atq_advertencia_timeout() -> void:
	print("b")
	ataque()
	advertencia.hide()
	atq_cooldown.start()
