extends CharacterBody2D
class_name EnemyTemplate

@onready var texture: Sprite2D = get_node("Texture")
@onready var floor_ray: RayCast2D = get_node("FloorRay")
@onready var animation: AnimationPlayer = get_node("Animation")

var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false

var player_ref: Player = null
var proximity_threshold: int
var raycast_default_position: int

const SPEED = 75.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	move_behavior()
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
	verify_position()
	texture.animate(velocity)

func move_behavior() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * SPEED
		
		else:
			velocity.x = 0
		
		return
	
	velocity.x = 0

func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
	return false
	
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		
		if direction > 0:
			texture.flip_h = true
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			floor_ray.position.x = raycast_default_position
