extends RigidBody2D

func _ready():
	$TTL.wait_time = randi_range(5, 12)

func _on_ttl_timeout():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
