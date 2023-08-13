extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_task()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var task = preload("res://main/Task.tscn")

func add_task():
	var task_instance = task.instance()
	$ScrollContainer/VBoxContainer2.add_child(task_instance)
