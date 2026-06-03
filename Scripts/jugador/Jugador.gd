extends CharacterBody2D
@export_category("Stats")
@export var vel : int = 150
@export var stamina : float = 100
@export var vida : float = 75
@export var vida_max : float = 100
@export var melee_damage : float = 50
@export var range_damage : float = 20
@export var explosive_damage : float = 80
@export var range_pierce : int = 1
#----------------------------------------------
var atacando : bool = false
var direction : Vector2
var cansado : bool = false
var recovery : bool = false
var invulnerable : bool = false
var dash : bool = false
var velocidad_dash_inicial = 750.0
var tiempo_entre_fantasmas = 0.05 
var cronometro_fantasmas = 0.0
#----------------------------------------------
@onready var sprite: Sprite2D = $Sprite
@onready var stamina_recover: Timer = $Stamina_recover
@onready var stamina_cooldown: Timer = $Stamina_recover/stamina_cooldown
@onready var curacion_cooldown: Timer = $curacion_cooldown
@onready var granada_cooldown: Timer = $granada_cooldown
@onready var dash_cooldown: Timer = $dash_cooldown
@onready var posicion_ataque: Node2D = $"Posicion ataque"
@onready var i_frames: Timer = $"i frames"
@onready var hurtbox: Area2D = $hurtbox
@onready var atq_delay_melee: Timer = $atq_delay_melee
@onready var atq_delay_pistola: Timer = $atq_delay_pistola
@onready var atq_delay_escopeta: Timer = $atq_delay_escopeta
@onready var melee_hitbox: Area2D = $"Posicion ataque/melee_hitbox"
@onready var FX: AnimationPlayer = $FX
@onready var animtree: AnimationTree = $AnimationTree
@onready var anim = $AnimationTree.get("parameters/playback")
@onready var pistola_pattern = preload("res://Recursos/assets/patron_pistola.tres")
@onready var escopeta_pattern = preload("res://Recursos/assets/patron_escopeta.tres")
#----------------------------------------------
@warning_ignore("unused_signal")
signal jugador_hit

func _ready() -> void:
	animtree.active = true
	vida = vida_max
	$_icono_mapa.show()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if vida <= 0:
		muerte()
		return
	if !Global.puede_mov:
		atq_delay_melee.stop()
		atq_delay_pistola.stop()
		atq_delay_escopeta.stop()
		hurtbox.monitorable = false
		hurtbox.monitoring = false

		return
	var direccion_apuntado = Input.get_vector("apuntar_izq", "apuntar_der", "apuntar_arriba", "apuntar_abajo")
	if Global.control:
		if direccion_apuntado.length() > 0.5:
			posicion_ataque.rotation = direccion_apuntado.angle()
			$"Posicion ataque/puntero".global_rotation = 0
			if direccion_apuntado.x < 0:
				$"Posicion ataque/slash".flip_v = true   
			else:
				$"Posicion ataque/slash".flip_v = false   
			
	else:
		posicion_ataque.look_at(get_global_mouse_position())
		$"Posicion ataque/puntero".global_rotation = 0
		if get_global_mouse_position().x < global_position.x:
			$"Posicion ataque/slash".flip_v = true    
		else:
			$"Posicion ataque/slash".flip_v = false
	
@warning_ignore("unused_parameter")
func _physics_process(delta) -> void:
	# movimiento
	if vida <= 0 or !Global.puede_mov:
		return
	if Global.puede_mov:
		if dash:
			cronometro_fantasmas += delta
			if cronometro_fantasmas >= tiempo_entre_fantasmas:
				crear_fantasma()
				cronometro_fantasmas = 0.0 
			move_and_slide()
			return
		direction = Input.get_vector("izq", "der", "arriba", "abajo").normalized()
		velocity = direction * vel
	else:
		velocity = Vector2.ZERO
	animaciones()
	flip()
	move_and_slide()
	
	#print(stamina_recover.is_stopped())
	#region habilidades

	if Input.is_action_pressed("habilidad_1") and stamina_cooldown.is_stopped():
		swift()
	
	if Input.is_action_pressed("habilidad_2") and dash_cooldown.is_stopped() and velocity != Vector2.ZERO:
		hacer_dash()
	
	if Input.is_action_pressed("habilidad_3") and curacion_cooldown.is_stopped():
		curacion()
	
	if Input.is_action_pressed("habilidad_4") and granada_cooldown.is_stopped():
		granada()
	#endregion
	
func swift():
	stamina_recover.start()
	vel = 250
	
func granada():
	granada_cooldown.start()
	$"Posicion ataque/granada".rotation_degrees = posicion_ataque.rotation_degrees
	$"Posicion ataque/granada".fire_pattern()
	
func curacion():
	curacion_cooldown.start()
	vida += 25
	
func hacer_dash():
	if direction == Vector2.ZERO:
		return 
		
	dash_cooldown.start()
	hurtbox.monitorable = false; hurtbox.monitoring = false
	dash = true
	velocity = direction.normalized() * velocidad_dash_inicial
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, 0.2)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_IN)

	tween.finished.connect(func(): dash = false; hurtbox.monitorable = true; hurtbox.monitoring = true)
	
func crear_fantasma():
	var fantasma = Sprite2D.new()
	
	fantasma.texture = sprite.texture
	fantasma.hframes = sprite.hframes 
	fantasma.vframes = sprite.vframes
	fantasma.frame = sprite.frame
	fantasma.global_position = sprite.global_position
	fantasma.scale = sprite.scale
	fantasma.flip_h = sprite.flip_h
	fantasma.flip_v = sprite.flip_v 
	fantasma.modulate = Color(0.0, 1.0, 1.0)
	fantasma.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	get_tree().current_scene.add_child(fantasma)
	var tween = get_tree().create_tween()
	tween.tween_property(fantasma, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(fantasma.queue_free)

func muerte():
	anim.travel("muerte")
	atq_delay_melee.stop()
	atq_delay_pistola.stop()
	atq_delay_escopeta.stop()
	$pantalla_muerte.show()
	hurtbox.monitorable = false
	hurtbox.monitoring = false

func flip():
	if direction.x <= -0.5:
		$Sprite.flip_h = true
	if direction.x >= 0.5:
		$Sprite.flip_h = false	
	if direction.y and direction.x == 0:
		$Sprite.flip_h = false	
		
func animaciones():
	if direction == Vector2.ZERO or !Global.puede_mov:
		anim.travel("idle")
	else:
		anim.travel("caminar")
		animtree.set("parameters/idle/blend_position", direction)
		animtree.set("parameters/caminar/blend_position", direction)
		
	#print(direction)

func _on_stamina_recover_timeout() -> void:
	vel = 150
	stamina_cooldown.start()

func _on_atq_delay_melee_timeout() -> void:
	if !Global.armas.has("cuchillo"):
		return
	if !Global.arma_act == 1:
		return
	melee_hitbox.enemigos_golpeados.clear()
	FX.play("ataque")
	
func _on_atq_delay_pistola_timeout() -> void:
	if !Global.arma_act == 2:
		return
	else:
		range_pierce = 1
	if Global.armas.has("pistola"):
		$"Posicion ataque/pistola".rotation_degrees = posicion_ataque.rotation_degrees
		$"Posicion ataque/pistola".fire_pattern()
	#print("ataque_rango")

func _on_atq_delay_escopeta_timeout() -> void:
	if !Global.arma_act == 3:
		return
	else:
		range_pierce = 3
	if Global.armas.has("escopeta"):
		$"Posicion ataque/escopeta".rotation_degrees = posicion_ataque.rotation_degrees
		$"Posicion ataque/escopeta".fire_pattern()
	
func _on_jugador_hit(enemigo_damage) -> void:
	if !i_frames.is_stopped():
		return
	$Camera2D.apply_shake(10)
	$SFX.play("hit")
	i_frames.start()
	var tween = create_tween()
	tween.tween_property(self, "vida", vida - enemigo_damage, 0.2)
	#print("invul")
	print("vida restante -> ",vida)
