extends RigidBody2D

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite2D as Sprite2D

func _ready():
	animation_player.play("Idle")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
