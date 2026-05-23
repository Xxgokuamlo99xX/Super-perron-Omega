extends CanvasLayer

@export var jugador: CharacterBody2D
@onready var shader_vida = load("res://Recursos/liquito.tres")

func _process(delta: float) -> void:
	$C/fps.text = "Fps:" + str(Engine.get_frames_per_second())
	#$SubViewportContainer/SubViewport/Camera2D.position = jugador.position
	$"C/El dinero".text = "Dinero: " + str(Global.dinero) 
	$vida/vida_label.text = "%.1f " % jugador.vida + "/" + "%.1f " % jugador.vida_max
	#print((jugador.vida) / jugador.vida_max)
	$vida.material.set_shader_parameter("health",(jugador.vida) / jugador.vida_max)

func _ready() -> void:
	show()
	$SubViewportContainer/SubViewport.world_2d = get_viewport().world_2d
