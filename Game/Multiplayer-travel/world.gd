extends Node2D
signal start
var map_scale= Vector2(512, 512)



func _ready():
	$world_map.position=map_scale/2-map_scale/2#plasse le joueur au centre de la map
	pass
func _process(delta):
	pass
	


func _on_multiplayer_go():
	start.emit()
	pass # Replace with function body.


func _on_multiplayer_username_transfer(name):
	var username=name # Replace with function body.
