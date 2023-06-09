extends Node
class_name PlayerStats

@onready var invincibility_timer: Timer = get_node("InvincibilityTimer")

var shielding: bool = false
var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 1
var base_magic_attack: int = 3
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_magic_attack: int = 0
var bonus_defense: int = 0

var current_health: int
var current_mana: int

var max_health: int
var max_mana: int

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	'1': 25,
	'2': 33,
	'3': 49,
	'4': 66,
	'5': 93,
	'6': 135,
	'8': 251,
	'9': 356
}

@export var animation: NodePath 
@onready var animation_player = get_node(animation) as AnimationPlayer

@export var player: NodePath
@onready var class_player = get_node(player) as CharacterBody2D

@export var collision_area: NodePath
@onready var player_collision_area = get_node(collision_area) as Area2D


func _ready() -> void:
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
	current_health = base_health + bonus_health
	max_health = current_health
	
func update_exp(value: int) -> void:
	current_exp += value
	if current_exp >= level_dict[str(level)] and level < 9:
		var leftover: int = current_exp - level_dict[str(level)]
		on_level_up()
		current_exp = leftover
		level += 1
	elif current_exp >= level_dict[str(level)] and level == 9:
		current_exp = level_dict[str(level)]

func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			if current_health >= max_health:
				current_health = max_health
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				class_player.dead = true
			else:
				class_player.on_hit = true
				class_player.attacking = false
	
func verify_shield(value: int) -> void:
	if shielding:
		if (base_defense + bonus_defense) >= value:
			return
			
		var damage = abs((base_defense + bonus_defense) - value)
		current_health -= damage
		
	else:
		current_health -= value
		print(current_health)
	
func update_mana(type: String, value: int) -> void:
	match type:
		'Increase':
			current_mana += value
			if current_mana >= max_mana:
				current_mana = max_mana
		'Decrease':
			current_mana -= value
	
	
	
	
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if Input.is_action_just_pressed("damage_teste"):
		update_health("Decrease", 5)


func _on_collision_area_area_entered(area):
	if area.name == "EnemyAttackArea":
		update_health("Decrease",area.damage)
		player_collision_area.set_deferred("monitoring", false)
		invincibility_timer.start(area.invincibility_timer)


func _on_invincibility_timer_timeout() -> void:
	player_collision_area.set_deferred("monitoring", true)
