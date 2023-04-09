extends Node2D
class_name Level

@onready var player: CharacterBody2D = get_node("Player")

func _ready():
	player.get_node("Texture").game_over.connect(on_game_over)

func on_game_over() -> void:
	get_tree().reload_current_scene()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
