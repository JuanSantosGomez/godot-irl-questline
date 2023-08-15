extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var PROGRESS_BAR = $VBoxContainer/CenterContainer/HBoxContainer
onready var TASKS_CONTAINER = $VBoxContainer/ScrollContainer/VBoxContainer2/VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	add_task()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
#	var output = []

#	print(output)


# Called every frame. 'delta' is the elapsed time since the previous frame.


var task = preload("res://main/Task.tscn")
func update_bars():
	var vali = 0
	var donetasks = 0
	var task_count = len(TASKS_CONTAINER.get_children())
	var subtasks = Vector2(0,0)
	for i in TASKS_CONTAINER.get_children():
		vali+=i.progress
		donetasks+=floor(i.progress/100)
		subtasks.x+=i.subtasks.x
		subtasks.y+=i.subtasks.y
		
	if task_count>0:
		if round(vali/task_count)>PROGRESS_BAR.progress:
			add_trauma()
		PROGRESS_BAR.progress=round(vali/task_count)
	else:
		PROGRESS_BAR.progress=0
	PROGRESS_BAR.labels = str(donetasks)+"/"+str(task_count)+" Tasks\n"+str(subtasks.x)+"/"+str(subtasks.y)+" Subtasks"
	
func add_task():
	var task_instance = task.instance()
	TASKS_CONTAINER.add_child(task_instance)
	task_instance.connect("progress_update", self, "update_bars")
	update_bars()


#SHAKER ALGORITHM

onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var default_decay = 0.96
export var decay = 0.99  # How quickly the shaking stops [0, 1].
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


func _on_Button_pressed():
	add_task()
