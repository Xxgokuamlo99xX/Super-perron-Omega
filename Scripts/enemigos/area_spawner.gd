extends Area2D

@export var enemigos : Array[DatosGenerador]
@export var area_spawn : CollisionShape2D
@export var oleadas : int
@export var delay : int
var oleada_act : int = 1
var oleada_curso = false
var enemigos_activos: Array[Node] = []
signal oleada_fin
@onready var oleada_delay: Timer = $oleada_delay
@export_category("Debug")
@export var color_linea: Color = Color.CYAN
@export var grosor: float = 2.0

func _draw():
	if area_spawn and area_spawn.shape is CircleShape2D:
		var centro = area_spawn.position
		var radio = area_spawn.shape.radius
		draw_arc(centro, radio, 0, TAU, 64, color_linea, grosor, true)

func _ready() -> void:
	oleada_delay.start(2)

func spawn(escena: PackedScene, pos: Vector2):
	var inst = escena.instantiate()
	get_parent().add_child(inst)
	inst.global_position = pos
	enemigos_activos.append(inst)
	inst.tree_exited.connect(_on_enemigo_muerto.bind(inst))
	
func generar():
	#print("check 1")
	var radio = area_spawn.shape.radius
	var centro = area_spawn.global_position
	while oleada_act <= oleadas:
		for item in enemigos:
			if item.oleada == oleada_act:
				for i in range(item.cantidad):
					#print("check 2")
					var angulo = randf() * TAU
					var distancia = sqrt(randf()) * radio
					var posicion_relativa = Vector2(cos(angulo), sin(angulo)) * distancia
					var posicion_final = centro + posicion_relativa
					spawn(item.enemigo, posicion_final)
		#print("check 4")
		break
		
func _on_oleada_fin() -> void:
	oleada_delay.start(delay)
	if oleada_act > oleadas:
		return
	#print("check 3")
	oleada_act += 1
	print(oleada_act)
	
func _on_oleada_delay_timeout() -> void:
	generar()

func _on_enemigo_muerto(referencia_enemigo):
	enemigos_activos.erase(referencia_enemigo)
	if enemigos_activos.is_empty():
		oleada_fin.emit()
