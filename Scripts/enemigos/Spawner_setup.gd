extends Resource
class_name DatosGenerador

@export var enemigo: PackedScene 
@export var cantidad: int = 1
@export var oleada : int = 1
@export_enum("Normal","Tanque","Especial")
var tipo: String ="Normal"
