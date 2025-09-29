extends CharacterBody3D

# ดึง AnimationPlayer ที่อยู่ใต้ Player ตรง ๆ
@onready var anim: AnimationPlayer = $AnimationPlayer

# ค่าพื้นฐาน
const SPEED := 5.0
const JUMP_VELOCITY := 8.0
const GRAVITY := 20.0

func _ready() -> void:
	if anim == null:
		push_error("❌ AnimationPlayer not found under Player node!")
	else:
		print("✅ AnimationPlayer found: ", anim.name)

func _physics_process(delta: float) -> void:
	# รับ input
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	)

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# เคลื่อนที่แนวนอน
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# หันตามทิศที่เดิน
		look_at(global_transform.origin + direction, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# กระโดด + แรงโน้มถ่วง
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		velocity.y -= GRAVITY * delta

	# ฟิสิกส์
	move_and_slide()

	# เล่นแอนิเมชัน
	if anim != null:
		if not is_on_floor():
			anim.play("Jump_Full_Short") # หรือ Jump_Full_Long ถ้าชอบ
		elif direction.length() > 0.1:
			anim.play("Running_A")
		else:
			anim.play("Idle")
