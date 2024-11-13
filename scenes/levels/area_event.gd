extends Area2D
class_name AreaEvent

enum EventType { LEVEL_END, TILEMAP_CHANGE, SPECIAL_EFFECT, TRIGGER_ANIMATION, GAME_OVER }

@export var event_type: EventType = EventType.LEVEL_END
@export var trigger_once: bool = true
@export var tilemap_target: NodePath
@export var effect_name: String = ""
@export var animation_name: String = ""
@export var triggered: bool = false

@export var end_screen : Node

signal event_triggered(event_type: int)

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if trigger_once and triggered:
		return

	triggered = true
	match event_type:
		EventType.LEVEL_END:
			handle_level_end()
		EventType.TILEMAP_CHANGE:
			handle_tilemap_change()
		EventType.SPECIAL_EFFECT:
			handle_special_effect()
		EventType.TRIGGER_ANIMATION:
			handle_trigger_animation()
		EventType.GAME_OVER:
			handle_game_over()

	emit_signal("event_triggered", event_type)

func handle_level_end():
	end_screen.show_message(true)
	end_screen.visible = true
	get_tree().paused = true

func handle_tilemap_change():
	if tilemap_target:
		var tilemap = get_node(tilemap_target) as TileMap
		if tilemap:
			tilemap.visible = true

func handle_special_effect():
	if effect_name != "":
		print("Activando efecto especial:", effect_name)

func handle_trigger_animation():
	if animation_name != "":
		print("Animación activada:", animation_name)

func handle_game_over():
	end_screen.show_message(false)
	end_screen.visible = true
	get_tree().paused = true
