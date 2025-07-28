extends Node2D

var BubbleScene = preload("res://bubble.tscn")

# --- PENGATURAN LAYOUT BARU ---
# Atur jarak dari tepi kiri/kanan layar (0.2 = 20% dari tepi).
@export var horizontal_margin_percent = 0.2
# Atur jarak dari tepi atas/bawah layar (0.2 = 20% dari tepi).
@export var vertical_margin_percent = 0.2
# Atur seberapa jauh bubble TENGAH menjorok KELUAR.
@export var middle_bubble_offset = 0.05
# (BARU) Atur seberapa jauh bubble ATAS/BAWAH masuk KE DALAM.
@export var outer_bubble_offset = 0.03

func _ready():
	spawn_bubbles()

func spawn_bubbles():
	var screen_size = get_viewport_rect().size

	# Hitung posisi Y untuk atas, tengah, dan bawah.
	var top_y = screen_size.y * vertical_margin_percent
	var bottom_y = screen_size.y * (1.0 - vertical_margin_percent)
	var usable_height = bottom_y - top_y
	var y_positions = [top_y, top_y + usable_height / 2, bottom_y]

	# Hitung posisi X dasar untuk kolom kiri dan kanan.
	var base_left_x = screen_size.x * horizontal_margin_percent
	var base_right_x = screen_size.x * (1.0 - horizontal_margin_percent)

	# Buat 3 bubble di sisi kiri dengan layout baru.
	for i in range(3):
		var x_pos = base_left_x
		# Jika ini bubble tengah (i=1), geser ke kiri (keluar).
		if i == 1:
			x_pos -= screen_size.x * middle_bubble_offset
		# Jika ini bubble atas atau bawah, geser ke kanan (ke dalam).
		else:
			x_pos += screen_size.x * outer_bubble_offset
		create_bubble(Vector2(x_pos, y_positions[i]))

	# Buat 3 bubble di sisi kanan dengan layout baru.
	for i in range(3):
		var x_pos = base_right_x
		# Jika ini bubble tengah (i=1), geser ke kanan (keluar).
		if i == 1:
			x_pos += screen_size.x * middle_bubble_offset
		# Jika ini bubble atas atau bawah, geser ke kiri (ke dalam).
		else:
			x_pos -= screen_size.x * outer_bubble_offset
		create_bubble(Vector2(x_pos, y_positions[i]))

func create_bubble(pos):
	var new_bubble = BubbleScene.instantiate()
	new_bubble.position = pos
	add_child(new_bubble)
