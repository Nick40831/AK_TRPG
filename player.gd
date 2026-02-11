class_name Player extends CharacterBody2D

var moving := false
var is_attacking := false

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite2D as Sprite2D
@onready var idle_timer := $IdleTimer as Timer

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 100
	move_and_slide()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("primary_click"):
		if not is_attacking:
			start_attack()
	else:
		if not is_attacking:
			handle_movement_animation()

func handle_movement_animation() -> void:
	if velocity.length() > 0:
		moving = true
		idle_timer.stop()

		sprite.flip_h = velocity.x < 0

		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
	else:
		if moving:
			moving = false
			animation_player.play("Stop")
			idle_timer.start()
			
func start_attack() -> void:
	is_attacking = true
	idle_timer.stop()
	animation_player.play("Attack01")
	
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Attack01":
		is_attacking = false

		# If button is still held, immediately attack again
		if Input.is_action_pressed("primary_click"):
			start_attack()	
		else:
			animation_player.play("Stop")
			idle_timer.start()

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_idle_timer_timeout() -> void:
	if velocity.length() == 0 and not is_attacking:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")
