extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var subtask = preload("res://main/SubTask.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update_progress():
	var _sons = []
	var ctr = 0
	var doned = 0
	for i in get_tree().get_nodes_in_group("tasks"):
		if i.father == self:
			if i.done:
				doned+=1
			ctr+=1
	$ProgressBar.value = 100*doned/ctr

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
	queue_free()
