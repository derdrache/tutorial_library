extends Resource
class_name GunResource

@export var model: PackedScene
@export var bulletSpawnOffset: Vector3
@export var damage: int
@export var shootCooldown: float
@export var reloadTime: float
@export var magazineSize: int
@export var bullets: int

func reload_count():
	if bullets < magazineSize: return bullets
	else: return magazineSize
