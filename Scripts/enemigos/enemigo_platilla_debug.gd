extends CharacterBody2D
class_name enemigos
@export var damage : float = 25
var vida : float
@export var vida_max : float = 100
@export var fuerza_empuje = 3000
@export var vel : int = 90
@export var dinero : int = 1
@onready var i_frames: Timer = $i_frames
@onready var detector = $detector_separacion
@onready var jugador = get_tree().get_first_node_in_group("jugador")
#borrar esta cuando sea enemigo normal
@export var ia : bool = true
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var dmg_number = preload("res://Escenas/Cosas/dmg_marker.tscn")
var siguiendo : bool = true
@onready var centro: RayCast2D = $deteccion_raycast/centro
@onready var deteccion: Area2D = $deteccion_raycast/Deteccion

@onready var recalc_timer: Timer = $RecalcTimer
var next_point
@warning_ignore("unused_signal")
signal enemigo_hit

@export var sprite : Sprite2D

func _ready() -> void:
	vida = vida_max
	recalc_timer.start() 

func _physics_process(delta: float) -> void:
	#for i in deteccion.get_overlapping_bodies():
		#if i.is_in_group("jugador") and ia:
			#if centro.is_colliding() and !siguiendo:
				##move_and_slide()
				#continue
			#siguiendo = true
	if vida <= 0:
		return
	if jugador.vida <= 0:
		siguiendo = false
	$deteccion_raycast.look_at(jugador.global_position)
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * vel
	velocity += calcular_vector_separacion() * fuerza_empuje * delta
	move_and_slide()
		
func calcular_vector_separacion() -> Vector2:
	var direccion_empuje = Vector2.ZERO
	var areas_solapadas = detector.get_overlapping_areas()
	
	if areas_solapadas.size() > 0:
		for area in areas_solapadas:
			var diff = global_position - area.get_parent().global_position
			if diff == Vector2.ZERO:#ESTO NO HACE NADA AL PARECER XDDDD
				diff = Vector2(randf_range(-100, 100), randf_range(-100, 100))
				#print(areas_solapadas)
			direccion_empuje += diff.normalized()
			
	return direccion_empuje.normalized()

func morir():
	sprite.hide()
	$morir.play("default")
	await $morir.animation_finished
	for i in dinero:
		var inst = Global.moneda.instantiate()
		inst.global_position = global_position
		get_parent().add_child(inst)
	queue_free()
	
func _on_enemigo_hit(damage_recibido) -> void:
	if !i_frames.is_stopped():
		return
	var numero = dmg_number.instantiate()
	numero.global_position = global_position - Vector2(0, 20)
	add_sibling(numero)
	numero.mostrar(damage_recibido)
	$AnimationPlayer.play("hit")
	vida -= damage_recibido
	i_frames.start()
	#print("vida enemigo -> ",vida)
	if vida <= 0:
		morir()
		
func _on_RecalcTimer_timeout():
	if jugador and siguiendo:
		agent.target_position = jugador.global_position
	
#func _on_rango_seguir_body_exited(body: Node2D) -> void:
	#siguiendo = false
	#recalc_timer.autostart = false
	#agent.target_position = global_position
