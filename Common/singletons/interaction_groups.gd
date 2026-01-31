extends Node

const INTERACT_GROUP_PREFIX: StringName = &"can_interact_with_"

# add an interaction group to the a node
func addInteractionGroup(node: Node, group: String) -> void:
	var formattedGroup = INTERACT_GROUP_PREFIX + group
	
	if not node.is_in_group(formattedGroup):
		node.add_to_group(formattedGroup)
	
# add several interactions group to the same node
func addInteractionGroups(node: Node, groups: Array[String]) -> void:
	for group in groups:
		addInteractionGroup(node, group)

# filter out non interact with group
func _isInteractGroup(group: StringName) -> bool:
	return group.begins_with(INTERACT_GROUP_PREFIX)

# check if two nodes can interact together
func canInteractWith(nodeA: Node, nodeB: Node) -> bool:
	var nodeAGroups = nodeA.get_groups().filter(_isInteractGroup)
	var nodeBGroups = nodeB.get_groups().filter(_isInteractGroup)
	
	# check if they have matching groups
	return nodeAGroups.any(func(groupA: StringName): return nodeBGroups.has(groupA))
