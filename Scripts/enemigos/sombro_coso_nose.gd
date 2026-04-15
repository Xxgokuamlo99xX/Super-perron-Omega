extends CharacterBody2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@export var player: NodePath 
var player_node: Node2D
var speed: float = 80.0
var siguiendo : bool = false
@onready var centro: RayCast2D = $deteccion_raycast/centro
@onready var deteccion: Area2D = $deteccion_raycast/Deteccion


@onready var recalc_timer: Timer = $RecalcTimer

func _ready():
	player_node = get_node(player)
	recalc_timer.start()  
	
func _physics_process(delta):
	for i in deteccion.get_overlapping_bodies():
		if i.is_in_group("jugador"):
			if centro.is_colliding() and !siguiendo:
				#move_and_slide()
				continue
			siguiendo = true
			recalc_timer.autostart = true
			#print("entre")
			
	$deteccion_raycast.look_at(player_node.global_position)
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func _on_RecalcTimer_timeout():
	if player_node and siguiendo:
		agent.target_position = player_node.global_position
	
func _on_rango_seguir_body_exited(body: Node2D) -> void:
	siguiendo = false
	recalc_timer.autostart = false
	agent.target_position = global_position
	#print("sali")
	
