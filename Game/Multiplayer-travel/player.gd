extends RigidBody2D


@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var heading = 0  #used for texture orientation
var targeting = false
@export var activated = true
func _ready():
	screen_size = get_viewport_rect().size
	

func _process(delta):
	rotation_degrees=0
	if activated and is_multiplayer_authority():
		set_user()
		$Camera2D.make_current()
		var velocity = Vector2.ZERO # The player's movement vector.

		if Input.is_action_pressed("move_right"):
			velocity.x += 1
			targeting= false
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			targeting= false
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
			targeting= false
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			targeting= false
		
		$RayCast2D.target_position = velocity.normalized()#raycast pour smooth les colisions
		
		#control par clic--------------------------------------
		if Input.is_mouse_button_pressed(1):
			$Target.global_position=get_global_mouse_position()
			targeting= true
		
		if targeting:
			var orientation = $Target.global_position-global_position
			velocity=orientation
			velocity = velocity.normalized()
   
		if global_position.distance_to($Target.global_position)<50:
			targeting = false
		


		if velocity.length() > 0 and not $RayCast2D.is_colliding() :
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
			$AnimatedSprite2D.animation= 'walking'
			heading = velocity.angle()
		else:
			$AnimatedSprite2D.animation= 'stand_still'
			$AnimatedSprite2D.stop()
		
		position += velocity * delta
		$AnimatedSprite2D.rotation = heading
	
	if name=="1": #admin dans ce cas
		pass
		
		
	


func _on_world_start():
	activated = true
	
func deactivate():
	activated = false

func set_user():
	$pseudo.text=comon_data.username#lit les données dpuis le singleton
	

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
