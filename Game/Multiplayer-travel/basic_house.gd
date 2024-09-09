extends StaticBody2D
signal entering(player)



func _on_door_body_entered(body):
	entering.emit(body)
	print(body, ' entered house')
