extends CanvasLayer

@export var jugador: CharacterBody2D

func _process(delta: float) -> void:
	$C/fps.text = "Fps:" + str(Engine.get_frames_per_second())
	#$SubViewportContainer/SubViewport/Camera2D.position = jugador.position
	$"C/El dinero".text = "Dinero: " + str(Global.dinero) 
	$vida/vida_label.text = str(jugador.vida) + "/" + str(jugador.vida_max)
	$vida.material.set_shader_parameter("health", (jugador.vida * 100) / jugador.vida_max)

func _ready() -> void:
	$SubViewportContainer/SubViewport.world_2d = get_viewport().world_2d
