extends Node2D

var esta_viendo : bool = false
@onready var cam: PhantomCamera2D = $cam
@export var cam_pos : Marker2D

func _ready() -> void:
	cam.global_position = cam_pos.global_position
	
func _on_area_interaccion_interactuo() -> void:
	esta_viendo = !esta_viendo
	if esta_viendo:
		cam.priority = 2
	else:
		cam.priority = 0

func _on_area_interaccion_body_exited(body: Node2D) -> void:
	if esta_viendo:
		cam.priority = 0
		esta_viendo = false
