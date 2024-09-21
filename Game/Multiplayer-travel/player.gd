extends RigidBody2D


@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var heading = 0  #used for texture orientation
var targeting = false
@export var activated = true
var chat = ''
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
   
		if global_position.distance_to($Target.global_position)<50 or not Input.is_mouse_button_pressed(1):
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
		
		
	###################################### gestion chat
	if len(comon_data.Chat.split("\n"))>2:
		$Camera2D/chat.text = (comon_data.Chat.split("\n")[-2]+"\n"+comon_data.Chat.split("\n")[-1]+"\n")#re split pour afficher que les dernières 2 lignes
	else:
		$Camera2D/chat.text = comon_data.Chat
	if Input.is_action_pressed("chat") and not $Camera2D/chat_input.editable:
		$Camera2D/chat_input.editable=true
		$Camera2D/chat_input.clear()
		$Camera2D/chat_input.grab_focus()
	


func _on_world_start():
	activated = true
	
func deactivate():
	activated = false

func set_user():
	$pseudo.text=comon_data.username#lit les données dpuis le singleton
	$Camera2D/chat.visible=true
	$Camera2D/chat_input.visible=true
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	


func _on_chat_input_text_submitted(new_text):
	var text = $pseudo.text +" : "+ new_text
	$Camera2D/chat_input.editable=false
	add_text_to_chat.rpc(text)
	
	
@rpc("any_peer", "reliable","call_local")
func add_text_to_chat(text): #fonction pour faire apliquer le chat
	comon_data.Chat += '\n'+text#utilisation d'un singleton pour que tout le monde ait le me chat
	
