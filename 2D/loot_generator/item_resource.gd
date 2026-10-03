extends Resource
class_name Item

enum TIER_LEVELS{COMMON = 0, RARE = 1, EPIC = 2}

@export var icon: CompressedTexture2D
@export var tierLevel: TIER_LEVELS
