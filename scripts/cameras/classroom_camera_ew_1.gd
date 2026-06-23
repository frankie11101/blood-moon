extends Camera3D

@export var player: CharacterBody3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if player:
		look_at(player.global_position) 
