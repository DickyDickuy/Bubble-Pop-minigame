extends Node2D
@export var pop_sounds: Array[AudioStream]

var initial_y_position: float
var time: float = 0.0
var float_speed: float = 1.5
var float_amplitude: float = 5.0

func _ready():
	initial_y_position = position.y
	# Start at a random point in the sine wave to desynchronize bubbles
	time = randf() * 10.0

func _process(delta):
	time += delta
	position.y = initial_y_position + sin(time * float_speed) * float_amplitude


func _on_area_2d_mouse_entered() -> void:
	print("Mouse entered!")
	$AnimationPlayer.play("squish")
	
			# Play the pop sound
	if not pop_sounds.is_empty():
		$AudioStreamPlayer2D.stream = pop_sounds.pick_random()
		$AudioStreamPlayer2D.play()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():

		if not $Sprite2D.visible:
			return

		# Sembunyikan bubble dan matikan collision-nya.
		$Sprite2D.hide()
		$Area2D/CollisionShape2D.disabled = true

		# --- LOGIKA PARTIKEL BARU YANG STABIL ---
		# Duplikasi node partikel asli, JANGAN pindahkan yang asli.
		var particles_instance = $GPUParticles2D.duplicate()

		# Tambahkan duplikat ke scene utama.
		get_parent().add_child(particles_instance)

		# Atur posisi dan nyalakan partikelnya.
		particles_instance.global_position = global_position
		particles_instance.emitting = true

		# Timer untuk menghapus HANYA duplikat partikelnya setelah selesai.
		var particle_timer = Timer.new()
		particle_timer.wait_time = particles_instance.lifetime
		particle_timer.one_shot = true
		particle_timer.timeout.connect(particles_instance.queue_free)
		particles_instance.add_child(particle_timer)
		particle_timer.start()

		# --- LOGIKA RESPAWN (TETAP SAMA) ---
		# Set timer untuk memunculkan kembali BUBBLE ini setelah 2 detik.
		var respawn_timer = get_tree().create_timer(2.0)
		respawn_timer.timeout.connect(_reset_bubble)

func _reset_bubble():
	# Fungsi ini akan dipanggil untuk memunculkan kembali bubble.
	$Sprite2D.show()
	$Area2D/CollisionShape2D.disabled = false
