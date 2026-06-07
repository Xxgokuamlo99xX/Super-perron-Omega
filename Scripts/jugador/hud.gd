extends CanvasLayer

@export var jugador: CharacterBody2D
@onready var shader_vida = load("res://Recursos/assets/liquito.tres")
@onready var slot_1: TextureRect = $slots2/Panel/slot_1
@onready var slot_2: TextureRect = $slots2/Panel2/slot_2
@onready var slot_3: TextureRect = $slots2/Panel3/slot_3
@onready var slot_4: TextureRect = $slots2/Panel4/slot_4
@onready var slot_fondo_1: TextureRect = $slots/TextureRect
@onready var slot_fondo_2: TextureRect = $slots/TextureRect2
@onready var slot_fondo_3: TextureRect = $slots/TextureRect3
@onready var slot_fondo_4: TextureRect = $slots/TextureRect4
@onready var slot_boton_1: Panel = $botones/Panel
@onready var slot_boton_2: Panel = $botones/Panel2
@onready var slot_boton_3: Panel = $botones/Panel3
@onready var slot_boton_4: Panel = $botones/Panel4
@onready var radial_menu: Control = $Control/RadialMenuAdvanced
@onready var armas_total : Array = radial_menu.get_children().map(func(hijo): return hijo.name)


func _process(delta: float) -> void:
	#if !Global.puede_mov:
		#hide()
	#else:
		#show()
	$C/fps.text = "Fps:" + str(Engine.get_frames_per_second())
	#$SubViewportContainer/SubViewport/Camera2D.position = jugador.position
	$"C/El dinero".text = str(Global.dinero_temp) + " :"
	#$vida/vida_label.text = "%.1f " % jugador.vida + "/" + "%.1f " % jugador.vida_max
	#print((jugador.vida) / jugador.vida_max)
	$vida.material.set_shader_parameter("health",(jugador.vida) / jugador.vida_max)
	#print((jugador.atq_delay_melee.wait_time  - jugador.atq_delay_melee.time_left)/ jugador.atq_delay_melee.wait_time)
	slot_1.material.set_shader_parameter("fill_ratio",(jugador.stamina_cooldown.wait_time  - jugador.stamina_cooldown.time_left)/ jugador.stamina_cooldown.wait_time)
	slot_2.material.set_shader_parameter("fill_ratio",(jugador.dash_cooldown.wait_time  - jugador.dash_cooldown.time_left)/ jugador.dash_cooldown.wait_time)
	slot_3.material.set_shader_parameter("fill_ratio",(jugador.curacion_cooldown.wait_time  - jugador.curacion_cooldown.time_left)/ jugador.curacion_cooldown.wait_time)
	slot_4.material.set_shader_parameter("fill_ratio",(jugador.granada_cooldown.wait_time  - jugador.granada_cooldown.time_left)/ jugador.granada_cooldown.wait_time)
	
	if Global.habilidades.has("dash"):
		slot_2.get_parent().show()
		slot_fondo_2.show()
		slot_boton_2.show()
	else:
		slot_2.get_parent().hide()
		slot_fondo_2.hide()
		slot_boton_2.hide()
		
	if Global.habilidades.has("curacion"):
		slot_3.get_parent().show()
		slot_fondo_3.show()
		slot_boton_3.show()
	else:
		slot_3.get_parent().hide()
		slot_fondo_3.hide()
		slot_boton_3.hide()
		
	if Global.habilidades.has("granada"):
		slot_4.get_parent().show()
		slot_fondo_4.show()
		slot_boton_4.show()
	else:
		slot_4.get_parent().hide()
		slot_fondo_4.hide()
		slot_boton_4.hide()
	
	for i in armas_total:
		if Global.armas.has(i):
			#print("Control/RadialMenuAdvanced" + i)
			get_node("Control/RadialMenuAdvanced/" + i).show()

		else:
			get_node("Control/RadialMenuAdvanced/" + i).hide()
	
	if Input.is_action_pressed("inventario"):
		radial_menu.enabled = true
		radial_menu.show()
		Engine.time_scale = 0.2
	else:
		Engine.time_scale = 1
		radial_menu.hide()
		
func _ready() -> void:
	radial_menu.hide()
	show()
	$SubViewportContainer/SubViewport.world_2d = get_viewport().world_2d

func _on_radial_menu_advanced_slot_selected(slot: Control, index: int) -> void:
	match slot.name:
		"cuchillo":
			Global.arma_act = 1
		"pistola":
			Global.arma_act = 2
		"escopeta":
			Global.arma_act = 3
		"nadaxddd":
			Global.arma_act = 4
