extends CharacterBody2D

var speed = 300
var maxSpeed = 500

func _ready() -> void:
	start()

func start():
	velocity = Vector2.DOWN * speed

func _physics_process(_delta: float) -> void:
	var lastVelocity = velocity
	
	#handle max speed
	velocity = velocity.clamp(Vector2(-maxSpeed, -maxSpeed), Vector2(maxSpeed, maxSpeed))

	move_and_slide()

	var collision = get_last_slide_collision()
	if collision:
		_on_collision(collision, lastVelocity)

func _on_collision(collision, lastVelocity):
		var collider = collision.get_collider()
		var isPaddle = collider is Paddle
		var isStone = collider is Stone
		
		var ballUnderPaddle = isPaddle and collider.global_position.y < global_position.y
		if not ballUnderPaddle:
			velocity = lastVelocity.bounce(collision.get_normal())
		
		if isPaddle:
			velocity *= 1.1
		elif isStone:
			collider.get_hit()
