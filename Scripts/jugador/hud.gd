extends CanvasLayer

var min : int = 15
var seg : int = 0 
var mil_seg : int = 0
@export var jugador: CharacterBody2D

func _process(delta: float) -> void:
	$C/fps.text = "Fps:" + str(Engine.get_frames_per_second())
	$SubViewportContainer/SubViewport/Camera2D.position = jugador.position

func _ready() -> void:
	$SubViewportContainer/SubViewport.world_2d = get_viewport().world_2d
