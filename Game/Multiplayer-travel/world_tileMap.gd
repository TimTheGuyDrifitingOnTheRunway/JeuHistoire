extends TileMap
var rng = RandomNumberGenerator.new()
var width = 512
var height = 512


func _ready():
	set_cell(0, local_to_map(Vector2(58,35)),1, Vector2i(16, 16))
	var texture = NoiseTexture2D.new()
	texture.noise = FastNoiseLite.new()
	await texture.changed
	print('generating',local_to_map(Vector2(35,58)), 1)
	for x in range(width):
		for y in range(height):
			pass

			
