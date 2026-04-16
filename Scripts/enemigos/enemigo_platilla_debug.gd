extends CharacterBody2D
@export var damage : float = 2
@export var vida : float = 50
@export var vida_max : float = 100
@export var fuerza_empuje = 3000
@export var vel : int = 50
@onready var i_frames: Timer = $i_frames
@onready var detector = $detector_separacion
@onready var jugador = get_tree().get_first_node_in_group("jugador")
#borrar esta cuando sea enemigo normal
@export var ia : bool = true

@warning_ignore("unused_signal")
signal enemigo_hit

func _ready() -> void:
	vida = vida_max

func _process(delta: float) -> void:
	debug()

func _physics_process(delta: float) -> void:
	if jugador and ia:
		var direction = global_position.direction_to(jugador.global_position)
		velocity = direction * vel
		velocity += calcular_vector_separacion() * fuerza_empuje * delta
		move_and_slide()
		
func debug():
	var progress_bar: ProgressBar = $Debug/ProgressBar
	progress_bar.max_value = vida_max
	progress_bar.value = vida
	
func calcular_vector_separacion() -> Vector2:
	var direccion_empuje = Vector2.ZERO
	var areas_solapadas = detector.get_overlapping_areas()
	
	if areas_solapadas.size() > 0:
		for area in areas_solapadas:
			var diff = global_position - area.get_parent().global_position
			if diff == Vector2.ZERO:
				diff = Vector2(randf_range(-100, 100), randf_range(-100, 100))
				print(areas_solapadas)
			direccion_empuje += diff.normalized()
			
	return direccion_empuje.normalized()

func _on_enemigo_hit(damage_recibido) -> void:
	if !i_frames.is_stopped():
		return
	i_frames.start()
	vida -= damage_recibido
	#print("vida enemigo -> ",vida)
	if vida <= 0:
		queue_free()
