extends Area2D
class_name DetectionArea

@export var enemy: NodePath
@onready var class_enemy = get_node(enemy) as CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_body_entered(body: Player) -> void:
	class_enemy.player_ref = body


func on_body_exited(body):
	pass # Replace with function body.
