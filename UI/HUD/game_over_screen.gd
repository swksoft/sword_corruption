extends CanvasLayer

@onready var cooldown_timer = $CooldownTimer

var can_reset := true

var win := false
@export var next_level : String = ""

func _ready():
	EVENTS.end_level.connect(on_end_level)

func show_message(state : bool):
	win = state
	if win == true:
		visible = true
		get_tree().paused = true
		$Control/VBoxContainer/UpperLabel.text = "YOU WIN"
		$Control/VBoxContainer/BottomLabel.text = "Press R to Retry
		or Enter to skip to the next level!"
	else:
		visible = true
		get_tree().paused = true
		$Control/VBoxContainer/UpperLabel.text = "YOU LOOSE"
		$Control/VBoxContainer/BottomLabel.text = "Press R to Retry"

func _process(delta):
	if Input.is_action_just_pressed("reset") and can_reset:
		can_reset = false
		cooldown_timer.start()
	if Input.is_action_just_pressed("next") and win == true:
		if next_level == "":
			return
		get_tree().paused = false
		get_tree().change_scene_to_file(next_level)
		

func _on_cooldown_timer_timeout():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func on_end_level():
	show_message(true)
