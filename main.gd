extends Node

@export var mob_scene: PackedScene
@export var bonus_scene: PackedScene

var score
var screen_size

func _ready():
	$Player.hide()
	screen_size = get_viewport().size
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BonusTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$Death.play()

func reload_game():
	get_tree().reload_current_scene()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bonus", "queue_free")
	$Music.play()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI/2
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$BonusTimer.start()
	$ScoreTimer.start()


func _on_bonus_timer_timeout():
	var bonus = bonus_scene.instantiate()
	var bonus_spawn_indicator = randi_range(0, 100)
	bonus.get_node("TTL").autostart = false
	
	if bonus_spawn_indicator < 51:
		var bonus_spawn_location = $MobPath/MobSpawnLocation
		bonus_spawn_location.progress_ratio = randf()
		var direction = bonus_spawn_location.rotation + PI/2
		bonus.position = bonus_spawn_location.position
		direction += randf_range(-PI/4, PI/4)
		bonus.rotation = direction
		var velocity = Vector2(randf_range(50.0, 150.0), 0.0)
		bonus.linear_velocity = velocity.rotated(direction)
	else:
		bonus.position = Vector2(randf_range(10, screen_size.x-10), randf_range(10, screen_size.y-10))
		bonus.get_node("TTL").autostart = true
	
	add_child(bonus)


func _on_player_get_bonus():
	score += 10
