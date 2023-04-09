extends Sprite2D
class_name EnemyTexture

@export var enemy: NodePath
@onready var class_enemy = get_node(enemy) as CharacterBody2D

@export var animation: NodePath
@onready var enemy_animation = get_node(animation) as AnimationPlayer

@export var attack_area: NodePath
@onready var attack_area_collision = get_node(attack_area) as CollisionShape2D

func animate(_velocity: Vector2) -> void:
	pass

func on_animation_finished(_anim_name: String) -> void:
	pass # Replace with function body.
