extends CharacterBody2D
@export_category("Stats")
@export var vel : int = 150
@export var stamina : float = 100
@export var vida : float = 75
@export var vida_max : float = 100
@export var melee_damage : float
@export var range_damage : float
@export var range_pierce : int = 1
#----------------------------------------------
var atacando : bool = false
var direction : Vector2
var cansado : bool = false
var recovery : bool = false
var invulnerable : bool = false
#----------------------------------------------
@onready var stamina_recover: Timer = $Stamina_recover
@onready var stamina_delay: Timer = $Stamina_delay
@onready var posicion_ataque: Node2D = $"Posicion ataque"
@onready var i_frames: Timer = $"i frames"
@onready var hurtbox: Area2D = $hurtbox
@onready var atq_delay_melee: Timer = $atq_delay_melee
@onready var atq_delay_rango: Timer = $atq_delay_rango
@onready var melee_hitbox: Area2D = $"Posicion ataque/melee_hitbox"
@onready var FX: AnimationPlayer = $FX
@onready var animacion: AnimationPlayer = $Animacion
@onready var animtree: AnimationTree = $AnimationTree

#----------------------------------------------
@warning_ignore("unused_signal")
signal jugador_hit

func _ready() -> void:
	$_icono_mapa.show()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if vida <= 0:
		muerte()
		return
	posicion_ataque.look_at(get_global_mouse_position())
	if get_global_mouse_position().x < global_position.x:
		$"Posicion ataque/slash".flip_v = true    # Voltear verticalmente si está a la izquierda
	else:
		$"Posicion ataque/slash".flip_v = false
	
	#region debug
	$debug/ProgressBar.value = stamina
	$debug/Label.text = "Cansado: " + str(cansado)
	$debug/ProgressBar2.value = vida
	$debug/ProgressBar2.max_value = vida_max
	#endregion
	
@warning_ignore("unused_parameter")
func _physics_process(delta) -> void:
	# movimiento
	if vida <= 0:
		return
	if Global.puede_mov:
		direction = Input.get_vector("izq", "der", "arriba", "abajo").normalized()
		velocity = direction * vel
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	animaciones()
	#print(stamina_recover.is_stopped())
	#region stamina
	if stamina <= 0 and !cansado:
		cansado = true
		$debug/ProgressBar.modulate = Color("RED")
		stamina_recover.start()
		recovery = true
		
	if cansado and stamina >= 100:
		$debug/ProgressBar.modulate = Color("GREEN")
		cansado = false
		
	if Input.is_action_pressed("sprint") and !cansado and velocity != Vector2(0,0):
		stamina -= 0.5
		vel = 250
		stamina_delay.start()
	else:
		if stamina <= 100 and stamina_delay.is_stopped() and !recovery:
			stamina += 0.75
		vel = 150
	#endregion
	
func muerte():
	atq_delay_melee.stop()
	atq_delay_rango.stop()
	$pantalla_muerte.show()
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	
func animaciones():
	if direction == Vector2.ZERO:
		animtree.travel("idle")
	else:
		animtree.travel("caminar")
		animacion.set("parameters/idle/blend_position", direction)
		animacion.set("parameters/caminar/blend_position", direction)

func _on_stamina_recover_timeout() -> void:
	recovery = false

func _on_atq_delay_melee_timeout() -> void:
	melee_hitbox.enemigos_golpeados.clear()
	FX.play("ataque")
	
func _on_atq_delay_rango_timeout() -> void:
	$"Posicion ataque/PatternShooter2D".rotation_degrees = posicion_ataque.rotation_degrees
	$"Posicion ataque/PatternShooter2D".fire_pattern()
	#print("ataque_rango")

func _on_jugador_hit(enemigo_damage) -> void:
	if !i_frames.is_stopped():
		return
	i_frames.start()
	var tween = create_tween()
	tween.tween_property(self, "vida", vida - enemigo_damage, 0.2)
	#print("invul")
	print("vida restante -> ",vida)
