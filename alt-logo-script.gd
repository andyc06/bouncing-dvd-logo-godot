extends Sprite2D

@export var speed: float = 400.0
@export var hues: Array = [0.0, 0.10, 0.3, 0.45, 0.6, 0.75, 0.82]

var direction: Vector2
var hue_index: int = 0

# Computed once at startup
var half_size: Vector2

func _ready() -> void:
	randomize()
	half_size = texture.get_size() * scale * 0.5

	# Shuffle hues and set initial color
	hues.shuffle()
	_next_hue()

	# Pick one of the four diagonal directions (45°, 135°, 225°, 315°)
	var quarter = PI * 0.5
	direction = Vector2.RIGHT.rotated(PI/4 + quarter * randi() % 4)


func _process(delta: float) -> void:
	position += direction * speed * delta

	var screen_size = get_viewport_rect().size

	# Horizontal bounce
	if position.x - half_size.x < 0 or position.x + half_size.x > screen_size.x:
		direction.x *= -1
		_next_hue()

	# Vertical bounce
	if position.y - half_size.y < 0 or position.y + half_size.y > screen_size.y:
		direction.y *= -1
		_next_hue()


func _next_hue() -> void:
	hue_index = (hue_index + 1) % hues.size()
	modulate = Color.from_hsv(hues[hue_index], 1.0, 1.0)
