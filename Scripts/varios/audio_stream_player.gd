extends AudioStreamPlayer

var canciones : Dictionary = {
	#poner aqui loads de las canciones
	"menu" : load("res://Recursos/Sonidos/Musica/psychronic-pixel-booster-362955.wav"),
	"lvl_1": load("res://Recursos/Sonidos/Musica/psychronic-galactic-gambit-363559.wav"),
	"lvl_2": load("res://Recursos/Sonidos/Musica/psychronic-hyperdrive-pixel-363006.wav"),
	"mapa": load("res://Recursos/Sonidos/Musica/WhatsApp Audio 2026-06-04 at 1.12.00 AM.mp3"),
	"tienda": load("res://Recursos/Sonidos/Musica/geoffreyburch-the-ghost-of-shepardx27s-pie-glbml-112816.mp3")
}
var cancion_act
var cancion_nom : String


func cambiar_cancion(Nombre : String):
	get_cancion(Nombre)
	stream = cancion_act
	
func get_cancion(Nombre_c : String):
	cancion_act = canciones[Nombre_c]
	cancion_nom = Nombre_c
	
func fade_in(duracion : float):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"volume_db", 0, duracion)
