extends Node3D

@onready var classroom_camera12b: Camera3D = $"Classroom Camera 12B"
@onready var classroom_camera12a: Camera3D = $"Classroom Camera 12A"
@onready var classroom_camera11b: Camera3D = $"Classroom Camera 11B"
@onready var classroom_camera11a: Camera3D = $"Classroom Camera 11A"
@onready var corridorb_camerab: Camera3D = $"CorridorB Camera B"
@onready var corridorb_cameraa: Camera3D = $"CorridorB Camera A"
@onready var corridorc_cameraa: Camera3D = $"CorridorC Camera A"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_classroom_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		classroom_camera12b.make_current()


func _on_corridor_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorb_camerab.make_current()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		classroom_camera11b.make_current()


func _on_corridor_area_c_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorb_cameraa.make_current()


func _on_corridor_area_d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorb_cameraa.make_current()


func _on_corridor_area_a_3_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorb_cameraa.make_current()


func _on_corridor_area_b_3_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorb_camerab.make_current()


func _on_classroom_area_12a_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		classroom_camera12a.make_current()


func _on_classroom_area_11a_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		classroom_camera11a.make_current()


func _on_corridor_area_a_4_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorb_cameraa.make_current()


func _on_corridor_c_area_a_1_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridorc_cameraa.make_current()
