extends StaticBody2D
class_name TreeInteractable

export(Array, Resource) var tree_list

onready var tree_texture: Sprite = get_node("TopTree")

var tree_dictionary: Dictionary = {
	"tree_name": "",
	"tree_drop_amount": []
}

func _ready() -> void:
	random_tree_selection()
		
		
func _process(_delta: float) -> void:
	if tree_texture.texture == null:
		queue_free()
		
		
func random_tree_selection() -> void:
	randomize()
	var random_value: int = randi() % 100 + 1
	for tree in tree_list:
		if random_value in range(tree.spawn_rate.min(), tree.spawn_rate.max()):
			populate_dictionary(tree)
			
			
func populate_dictionary(tree: Object) -> void:
	tree_dictionary.tree_name = tree.interactable_name
	tree_texture.texture = tree.interactable_image
	tree_dictionary.tree_drop_amount = tree.drop_amount
