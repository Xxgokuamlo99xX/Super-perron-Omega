@tool
extends Area2D
class_name Projectile2D

signal body_hit(projectile: Projectile2D, body: Node2D)
signal max_range_reached(projectile: Projectile2D)

var range: float = 100.0
var speed: float = 10.0
var speed_ramp: Curve = null
var delay: float = 0.0
var enemigos_golpeados : Array

var trajectory: Trajectory2D
var travel_angle: float = 0.0

var dist: float = 0.0
var rot: bool = false
var wait_for_delay: bool = false
var run_in_editor: bool = false

@onready var dist_left: float = range
@onready var jugador = get_tree().get_first_node_in_group("jugador")

func _ready() -> void:
	if Engine.is_editor_hint() and not run_in_editor:
		return
	rot = travel_angle != 0.0
	wait_for_delay = delay > 0.0
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	queue_free()
 
func end_path() -> void:
	emit_signal("max_range_reached", self)
	queue_free()


func _physics_process(delta: float) -> void:
	aplicar_atq(jugador.range_damage)
	if Engine.is_editor_hint() and not run_in_editor:
		set_physics_process(false)
		return
	if !trajectory:
		return
	
	if wait_for_delay:
		delay -= delta
		wait_for_delay = delay > 0.0
		return
	if dist_left <= 0:
		end_path()
		return
	var s: float = speed
	if speed_ramp:
		s = speed_ramp.sample(dist/range)
	var dt: float = delta*s
	dist += dt
	dist_left -= dt
	var move_delta: Vector2 = trajectory.get_delta(dt, dist)
	if rot:
		move_delta = move_delta.rotated(deg_to_rad(travel_angle))
	position += move_delta
	
func aplicar_atq(damage : float):
	for area in get_overlapping_areas():
		if area.is_in_group("enemigo"):
			if enemigos_golpeados.has(area):
				return
			area.get_parent().emit_signal("enemigo_hit",damage)
			enemigos_golpeados.append(area)
			if enemigos_golpeados.size() == jugador.range_pierce:
				queue_free()
