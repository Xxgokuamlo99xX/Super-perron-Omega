extends CharacterBody2D
@export_category("Stats")
@export var vel : int = 150
@export var stamina : float = 100
@export var vida : float = 20
@export var vida_max : float = 25
@export var melee_damage : float
@export var range_damage : float
@export var range_pierce : int = 1
@export var atacando : bool = false
#----------------------------------------------
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
@onready var melee_hitbox: Area2D = $"Posicion ataque/melee_hitbox"
@onready var animation: AnimationPlayer = $AnimationPlayer
#----------------------------------------------
@warning_ignore("unused_signal")
signal jugador_hit

func _ready() -> void:
	$_icono_mapa.show()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	posicion_ataque.look_at(get_global_mouse_position())
	if get_global_mouse_position().x < global_position.x:
		$"Posicion ataque/Sprite2D".flip_v = true    # Voltear verticalmente si está a la izquierda
	else:
		$"Posicion ataque/Sprite2D".flip_v = false
	
	#region debug
	$debug/ProgressBar.value = stamina
	$debug/Label.text = "Cansado: " + str(cansado)
	$debug/ProgressBar2.value = vida
	$debug/ProgressBar2.max_value = vida_max
	#endregion
	
@warning_ignore("unused_parameter")
func _physics_process(delta) -> void:
	# movimiento
	if Global.puede_mov:
		direction = Input.get_vector("izq", "der", "arriba", "abajo").normalized()
		velocity = direction * vel
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	#print(stamina_recover.is_stopped())
	#region stamina
	if Input.is_action_pressed("sprint") and !cansado and velocity != Vector2(0,0):
		stamina -= 0.5
		vel = 250
		stamina_delay.start()
	else:
		if stamina <= 100 and stamina_delay.is_stopped() and !recovery:
			stamina += 0.75
		vel = 150
	#endregion
	
func _on_stamina_recover_timeout() -> void:
	recovery = false

func _on_atq_delay_melee_timeout() -> void:
	melee_hitbox.enemigos_golpeados.clear()
	animation.play("ataque")
	
func _on_atq_delay_rango_timeout() -> void:
	$"Posicion ataque/PatternShooter2D".rotation_degrees = posicion_ataque.rotation_degrees
	$"Posicion ataque/PatternShooter2D".fire_pattern()
	#print("ataque_rango")

func _on_jugador_hit(enemigo_damage) -> void:
	if !i_frames.is_stopped():
		return
	i_frames.start()
	vida -= enemigo_damage
	#print("invul")
	print("vida restante -> ",vida)
