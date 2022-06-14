extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var sync_position = Vector2.ZERO

@onready var use_child = "--use-child" in OS.get_cmdline_args()

func _ready():
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())
		$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
		$SyncState/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$Camera2D.current = is_multiplayer_authority()
		
func _physics_process(delta):
	if not is_multiplayer_authority():
		if not use_child:
			position = sync_position
		else:
			position = $SyncState.sync_position
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	sync_position = position
	$SyncState.sync_position = position
