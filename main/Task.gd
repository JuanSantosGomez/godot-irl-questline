extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var subtask = preload("res://main/SubTask.tscn")
var progress = 0
var subtasks = Vector2(0,0)
signal progress_update()
onready var PROGRESS_BAR = $ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	run_smoothing()

func run_smoothing():
	PROGRESS_BAR.value += ((progress-PROGRESS_BAR.value)/20)
	set_physics_process(!(abs(PROGRESS_BAR.value-progress) < 1))
	PROGRESS_BAR.value += (progress-PROGRESS_BAR.value)*int((abs(PROGRESS_BAR.value-progress) < 1))



func update_progress():
	var _sons = []
	var ctr = 0
	var doned = 0
	for i in get_tree().get_nodes_in_group("tasks"):
		if i.father == self:
			if i.done:
				doned+=1
			ctr+=1
	
	subtasks.x = doned
	subtasks.y = ctr
	
	progress = 100*doned/ctr
	set_physics_process(true)
	emit_signal("progress_update")

func add_subtask():
	var subtask_instance = subtask.instance()
	subtask_instance.father = self
	$VBoxContainer.add_child(subtask_instance)
	update_progress()

func _on_Button_pressed():
	add_subtask()

func removeme(target):
	
	target.queue_free()
	update_progress()


func _on_TextureButton_toggled(button_pressed):
	if button_pressed:
		$VBoxContainer.show()
		$HBoxContainer2.show()
	else:
		$VBoxContainer.hide()
		$HBoxContainer2.hide()


func _on_delButton_pressed():
	get_parent().remove_child(self)
	emit_signal("progress_update")
	queue_free()
