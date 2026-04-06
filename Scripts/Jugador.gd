extends CharacterBody2D

var vel : int = 150
var stamina : float = 100
var direction : Vector2
var can_move : bool = true
var ataque : bool = true
var cansado : bool = false
var recovery : bool = false
@onready var stamina_recover: Timer = $Stamina_recover
@onready var stamina_delay: Timer = $Stamina_delay

func _physics_process(delta) -> void:
	if Global.puede_mov:
		direction = Input.get_vector("izq", "der", "arriba", "abajo").normalized()
		velocity = direction * vel
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	$debug/ProgressBar.value = stamina
	$debug/Label.text = "Cansado: " + str(cansado)
	
	#print(stamina_recover.is_stopped())
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

func _on_stamina_recover_timeout() -> void:
	recovery = false
