extends Resource
class_name TalentResource

@export var talentIcon: CompressedTexture2D
@export var is_unlocked := false
@export var unlockTalents : Array[TalentResource]

@export var stat: Stats
@export var statValue: int

enum Stats{HEALTH, ATTACK}
