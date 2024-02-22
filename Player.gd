extends Area2D

signal hit
signal get_bonus

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var velocity = input_direction * speed
	if $AnimatedSprite2D.animation == "end":
		pass
	elif input_direction == Vector2.ZERO:
		rotation = 0
		$AnimatedSprite2D.play("idle")
	else:
		rotation = input_direction.angle() + PI/2
		$AnimatedSprite2D.play("fly")
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	
func _on_body_entered(body):
	if body.is_in_group("mobs") :
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("end")
		await get_tree().create_timer(end_duration($AnimatedSprite2D, "end")).timeout
		hide()
	elif body.is_in_group("bonus"):
		get_bonus.emit()

func start(pos):
	position = pos
	$AnimatedSprite2D.animation = "idle"
	show()
	$CollisionShape2D.disabled = false
	
func end_duration(anima:AnimatedSprite2D, anima_name:String) -> float:
	var duration = anima.sprite_frames.get_frame_count(anima_name) / anima.sprite_frames.get_animation_speed(anima_name)
	return duration
