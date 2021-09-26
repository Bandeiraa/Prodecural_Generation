extends Node2D
class_name WorldManager

onready var y_sort: YSort = get_node("YSort")
onready var tile: TileMap = get_node("Grass")

export(float) var grid_size = 16.0
export(PackedScene) var tree_scene
export(int) var tree_amount
export(int) var decoration_tile_amount
export(int) var x_size
export(int) var y_size

var decoration_list: Array
var position_list: Array

func _ready() -> void:
	randomize()
	generate_base_tile(x_size, y_size)
		
		
func generate_base_tile(width, height) -> void:
	for x in width:
		for y in height:
			tile.set_cell(x, y, 0)
			#yield(get_tree().create_timer(0.01), "timeout")
			
	generate_decoration_tile()
			
			
func generate_decoration_tile() -> void:
	for decoration in decoration_tile_amount:
		var random_pos: Array = random_spawn_position(x_size, y_size)
		tile.set_cell(random_pos[0], random_pos[1], randi() % 11 + 1)
		#yield(get_tree().create_timer(0.2), "timeout")
		
	for tree in tree_amount:
		spawn_tree()
		#yield(get_tree().create_timer(0.2), "timeout")
		
		
func random_spawn_position(width, height) -> Array:
	var x_pos: int = randi() % width
	var y_pos: int = randi() % height
	if decoration_list.has(Vector2(x_pos, y_pos)):
		return random_spawn_position(width, height)
	else:
		decoration_list.append(Vector2(x_pos, y_pos))
		return [x_pos, y_pos]
		
		
func spawn_tree() -> void:
	var tree_to_spawn: Object = tree_scene.instance()
	y_sort.add_child(tree_to_spawn)
	var random_pos: Array = spawn_position()
	tree_to_spawn.global_position = Vector2(random_pos[0], random_pos[1]) * grid_size
	 
	
func spawn_position() -> Array:
	var used_tile_rect: Rect2 = tile.get_used_rect()
	var x_pos: float = randi() % int(used_tile_rect.size.x - 2) + (used_tile_rect.position.x + 1)
	var y_pos: float = randi() % int(used_tile_rect.size.y - 2) + (used_tile_rect.position.y + 1)
	if position_list.has(Vector2(x_pos, y_pos)) or decoration_list.has(Vector2(x_pos, y_pos)):
		return spawn_position()
	else:
		position_list.append(Vector2(x_pos, y_pos))
		return [x_pos, y_pos]
				
				
func _process(_delta: float):
	if Input.is_action_just_pressed("ui_up"):
		return get_tree().reload_current_scene()
