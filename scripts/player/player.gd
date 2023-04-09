extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture")
@onready var wall_ray: RayCast2D = get_node("WallRay")
@onready var collision2D: CollisionShape2D = get_node("Collision")
@onready var stats: PlayerStats = get_node("Stats")

const SPEED = 75.0
const JUMP_VELOCITY = -200.0
const FLOOR_NORMAL = Vector2.UP
const wall_jump_speed = 30.0
const wall_impulse_speed = -200.0


var dead: bool = false
var on_hit: bool = false
var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var not_on_wall: bool = true
var wall_velocity: int = -300.0

var can_track_input = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float):
	var direction = Input.get_axis("ui_left", "ui_right")
	actions_env()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > gravity:
			velocity.y = gravity
		
	# Handle Jump.
	if next_to_wall() and not is_on_floor():
		velocity.y = wall_jump_speed
		if Input.is_action_just_pressed("ui_accept"):
			direction = 0
			velocity.x = wall_velocity
			velocity.y = wall_impulse_speed
			
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_track_input and not attacking:
		velocity.y = JUMP_VELOCITY
		
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if direction and can_track_input and not attacking:
		if direction == 1:
			wall_velocity = -300
			wall_ray.rotation = 0
			collision2D.position.x = -3
		elif direction == -1:
			wall_velocity = 300
			wall_ray.rotation = deg_to_rad(180)
			collision2D.position.x = 3
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var slide = get_slide_collision(-1)
		if slide:
			velocity = velocity.slide(slide.normal)
	move_and_slide()
	player_sprite.animate(velocity)
	
	
func actions_env() -> void:
	attack()
	crouch()
	defense()
	
func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true
	
func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouching_off = true

func defense() -> void:
	if Input.is_action_pressed("defend") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
		stats.shielding = true
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true
		stats.shielding = false
		
func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		velocity.y = 0
		not_on_wall = false
		return true
	else:
		not_on_wall = true
		return false
