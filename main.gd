extends Node3D

@onready var classroom_camera: Camera3D = $"Classroom Camera"
@onready var corridor_camera: Camera3D = $"Corridor Camera"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_classroom_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		classroom_camera.make_current()


func _on_corridor_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		corridor_camera.make_current()
