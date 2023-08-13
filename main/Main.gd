extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_task()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.


var task = preload("res://main/Task.tscn")
func update_bars():
	var vali = 0
	
	for i in $ScrollContainer/VBoxContainer2/VBoxContainer.get_children():
		vali+=i.progress
	
	if round(vali/len($ScrollContainer/VBoxContainer2/VBoxContainer.get_children()))>$ScrollContainer/VBoxContainer2/CenterContainer/HBoxContainer.progress:
		add_trauma()
	
	$ScrollContainer/VBoxContainer2/CenterContainer/HBoxContainer.progress=round(vali/len($ScrollContainer/VBoxContainer2/VBoxContainer.get_children()))
func add_task():
	var task_instance = task.instance()
	$ScrollContainer/VBoxContainer2/VBoxContainer.add_child(task_instance)
	task_instance.connect("progress_update", self, "update_bars")


#SHAKER ALGORITHM

onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var default_decay = 0.8
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(50, 30)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.
var faster = 0.001
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var positionality = Vector2(0,0)


func add_trauma(amount=10):
	trauma = min(trauma + amount, 1.0)
	positionality = rect_global_position
	set_physics_process(true)

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rect_rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	rect_position.x = positionality.x+max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	rect_position.y = positionality.y+max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func shakers(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	else:
		decay=default_decay
		get_node("../../..").visible = false
		get_node("../../..").visible = true
		set_physics_process(false)

func _physics_process(delta):
	shakers(delta)
