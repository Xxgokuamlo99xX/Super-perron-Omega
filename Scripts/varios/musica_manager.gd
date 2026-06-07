extends Node

@export var fade_duration : int
@export_enum("menu","lvl_1","lvl_2","mapa","tienda")
var musica_cambio : String
@export var muteado : bool = false


func _ready() -> void:
	if not musica_cambio == GlobalAudio.cancion_nom && not muteado:
		GlobalAudio.cambiar_cancion(musica_cambio)
		GlobalAudio.play()
		GlobalAudio.fade_in(fade_duration)
		
	else:
		return
	if muteado:
		GlobalAudio.volume_db = -80
	else:
		GlobalAudio.volume_db = 0
	
func _bajar_volumen():
	var tween = get_tree().create_tween()
	tween.tween_property(GlobalAudio,"volume_db", -80, 3)
	
func _subir_volumen():
	var tween = get_tree().create_tween()
	tween.tween_property(GlobalAudio,"volume_db", 0, 3)
