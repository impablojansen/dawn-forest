extends Sprite2D
class_name PlayerTexture

var suffix: String = "_right"
var normal_attack: bool = false
var shield_off: bool = true
var crouching_off: bool = false

@export var animation: NodePath 
@onready var animation_player = get_node(animation) as AnimationPlayer

@export var player: NodePath
@onready var class_player = get_node(player) as CharacterBody2D

func animate(direction: Vector2) -> void:
	verify_position(direction)
	if class_player.attacking or class_player.defending or class_player.crouching:
		action_behavior()
	elif direction.y != 0:
		vertical_behavior(direction)
	elif class_player.landing == true:
		animation_player.play("land")
		class_player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	
func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		suffix = "_right"
		flip_h = false
	elif direction.x < 0:
		suffix = "_left"
		flip_h = true

func action_behavior() -> void:
	if class_player.attacking and normal_attack:
		animation_player.play("attack" + suffix)
	elif class_player.defending and shield_off:
		animation_player.play("shield")
		shield_off = false
	elif class_player.crouching and crouching_off:
		animation_player.play("crouch")
		crouching_off = false

func horizontal_behavior(direction: Vector2) -> void:
	if get_parent().velocity.x != 0:
		animation_player.play("running")
	else:
		animation_player.play("idle")

func vertical_behavior(direction: Vector2) -> void:
	if get_parent().velocity.y < 0:
		class_player.landing = true
		animation_player.play("jump")
	elif get_parent().velocity.y == 30:
		animation_player.play("wall_slide")
	elif get_parent().velocity.y > 0:
		animation_player.play("fall")

# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_animation_finished(anim_name: String):
	match anim_name:
		"land":
			class_player.landing = false
			class_player.set_physics_process(true)
		"attack_left":
			normal_attack = false
			class_player.attacking = false
		"attack_right":
			normal_attack = false
			class_player.attacking = false
