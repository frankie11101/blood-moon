extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# Higher number = faster turning. Lower number = slower, weightier turning.
const ROTATION_SPEED = 10.0

var last_camera: Camera3D = null
var locked_direction := Vector3.ZERO
var is_input_locked := false

@onready var raycast = $RayCast3D
@onready var holdMarker = $"HoldMarker Node3D"

var carriedObject: Node3D

func _unhandled_input(event):
	if event.is_action_pressed("interact"): # "E" key
		if carriedObject == null:
			tryPickUp()
		else:
			dropObject()

func tryPickUp():
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target is RigidBody3D:
			carriedObject = target
			
			# Tell the object to ignore collisions with the player while carried
			# Freeze the physics so it stops falling or reacting to gravity
			# finally snap it exactly on the marker's position
			carriedObject.add_collision_exception_with(self)
			carriedObject.freeze = true
			carriedObject.get_parent().remove_child(carriedObject)
			holdMarker.add_child(carriedObject)
			
			carriedObject.position = Vector3.ZERO
			carriedObject.rotation = Vector3.ZERO

func dropObject():
	if carriedObject != null:
		var world = get_tree().current_scene #get main
		var globalPos = carriedObject.global_position # to remember position before unparenting
		
		holdMarker.remove_child(carriedObject)
		world.add_child(carriedObject)
		
		carriedObject.global_position = globalPos
		carriedObject.remove_collision_exception_with(self)
		carriedObject.freeze = false
		
		var forwardDirection = -global_transform.basis.z # CALCULATE THE TOSS FORCE
		var horizontalForce = 3.0 # Define how hard you want to push it
		var upwardForce = 2.0
		
		var tossVelocity = (forwardDirection * horizontalForce) + (Vector3.UP * upwardForce)
		
		carriedObject.linear_velocity = tossVelocity
		
		carriedObject = null

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
		#Check if the camera swapped while holding direction
		if last_camera != null and camera != last_camera and not is_input_locked:
			is_input_locked = true #locked direction keeps its value from the prev frame
		if is_input_locked:
			direction = locked_direction
		else:
			var cam_forward := camera.global_transform.basis.z
			var cam_right := camera.global_transform.basis.x
			
			cam_forward.y = 0
			cam_right.y = 0
			cam_forward = cam_forward.normalized()
			cam_right = cam_right.normalized()
			
			direction = (cam_right * input_dir.x + cam_forward * input_dir.y).normalized()
			locked_direction = direction
	else:
		is_input_locked = false
	
	last_camera = camera
	
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
