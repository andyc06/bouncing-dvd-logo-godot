extends Sprite2D

var speed = 400
var direction = Vector2.ZERO

# sprite's post-scaled dimensions
var current_width = self.scale.x * self.get_rect().size.x
var current_height = self.scale.y * self.get_rect().size.y

var angles = [45, 135, 225, 315]

var hues = [0.0, 0.10, 0.3, 0.45, 0.6, 0.75, 0.82]
# starting index
var hue_index = 0

func increment_hue() -> void:
	 # increment to the next hue index and then wrap around
	hue_index = (hue_index + 1) % (hues.size() - 1)
	var hue = hues[hue_index]
	self_modulate = Color.from_hsv(hue, 1.0, 1.0, 1.0)
	print("hue index: ", hue_index, " | set to hue value: ", hue)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pick a random initial direction
	angles.shuffle()
	direction = Vector2.from_angle(angles[0])
	print("initial angle: ", angles[0], " | initial direction: ", direction)
	# randomize the color order every time the program starts
	hues.shuffle()
	# set an initial color
	increment_hue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# probably not great to keep recalculating this on every frame!
	var viewport_rect = get_viewport().get_visible_rect()
	
	position += direction * speed * delta
	
	# Wall collisions
	#
	# The viewport rectangle `position` is its upper left corner & `end` is its lower right corner
	#
	# Because the sprite's position is measured from its center, the edge of the sprite
	# is touching the edge of the viewport when its position +/- half of the width or height 
	# reaches the X or Y position of that edge of the viewport rectangle
	#
	# Sprite direction is bounced off of a unit vector pointing inwards from each edge of the viewport
	#
	# Here's a little diagram of the vectors used for the bounce!
	#
	#                                  Top                                         
	#       ┌───────────────────────────┬──────────────────────────────┐           
	#       │                           │                              │           
	#       │                           │                              │           
	#       │                           ▼              <- xx           │           
	#       │                                              xxxx        │           
	#       │                                                 xxxx     │           
	#       │                                                    xxx   │           
	#       │                                                      xxx │           
	#  Left ├──────►                       bounce normal (LEFT) ◄──────┤ Right     
	#       │                                                       xx │           
	#       │                                                     xxx  │           
	#       │                                                  xxxx    │           
	#       │                                    logo path   xxx       │           
	#       │                                              xxx         │           
	#       │                           ▲               xxxx           │           
	#       │                           │          -> xx               │           
	#       │                           │                              │           
	#       └───────────────────────────┴──────────────────────────────┘           
	#                                Bottom                                        
																				 
	
	# Top
	if position.y <= viewport_rect.position.y + (current_height / 2):
		direction = direction.bounce(Vector2.DOWN)
		increment_hue()
	
	# Bottom
	if position.y >= viewport_rect.end.y - (current_height / 2):
		direction = direction.bounce(Vector2.UP)
		increment_hue()
	
	# Right
	if position.x >= viewport_rect.end.x - (current_width / 2):
		direction = direction.bounce(Vector2.LEFT)
		increment_hue()
	
	# Left
	if position.x <= viewport_rect.position.x + (current_width / 2):
		direction = direction.bounce(Vector2.RIGHT)
		increment_hue()
