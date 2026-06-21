extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# Higher number = faster turning. Lower number = slower, weightier turning.
const ROTATION_SPEED = 10.0 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 1. Get the raw 2D input from WASD / Arrow keys
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Get the currently active camera in the scene
	var camera := get_viewport().get_camera_3d()
	
	var direction := Vector3.ZERO
	
	# 3. If there is an active camera and the player is pressing a key
	if camera and input_dir != Vector2.ZERO:
		# Using your updated configuration without the negative sign
		var cam_forward := camera.global_transform.basis.z
		var cam_right := camera.global_transform.basis.x
		
		cam_forward.y = 0
		cam_right.y = 0
		cam_forward = cam_forward.normalized()
		cam_right = cam_right.normalized()
		
		direction = (cam_right * input_dir.x + cam_forward * input_dir.y).normalized()

	# 4. Apply movement and rotation
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# --- SMOOTH ROTATION LOGIC START ---
		# Create a target rotation looking at our movement direction, keeping Vector3.UP
		var target_basis := Basis.looking_at(direction, Vector3.UP)
		var target_quaternion := Quaternion(target_basis)
		
		# Slerp shifts our current rotation toward the target rotation.
		# delta * ROTATION_SPEED ensures it looks smooth regardless of frame rate.
		var current_quaternion := Quaternion(global_transform.basis)
		var next_quaternion := current_quaternion.slerp(target_quaternion, delta * ROTATION_SPEED)
		
		# Apply the calculated smooth rotation back to the player
		global_transform.basis = Basis(next_quaternion)
		# --- SMOOTH ROTATION LOGIC END ---
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
