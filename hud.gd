extends CanvasLayer

signal start_game
signal reload_game

func _ready():
	$ReloadButton.hide()
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$ReloadButton.hide()
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$ExitBotton.show()

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	$ExitBotton.hide()
	$ReloadButton.show()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func _on_reload_button_pressed():
	reload_game.emit()


func _on_exit_botton_pressed():
	get_tree().quit()
