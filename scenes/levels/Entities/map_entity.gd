extends Area2D
class_name MapEntity

@export var name_entity: String = "None"
@export var is_collectible: bool = false
@export var is_hazard : bool = false
@export var is_trap: bool = false
@export var value: int = 0
@export var sfx : String = ""

func on_interact():
	# [something]
	pass

func init_entity(name: String, is_collectible: bool, is_hazard: bool, value: int, sfx = ""):
	self.name = name
	self.is_collectible = is_collectible
	self.is_hazard = is_hazard
	self.value = value
	self.sfx = sfx

func _on_area_entered(area):
	on_interact()

# FIXME: SI LE ATACA EL HIPER CARGADO DEBERIA DESAPARECER SIN MAS
