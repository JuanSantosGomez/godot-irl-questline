extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var done = false
var father
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		done = true
		$LineEdit.modulate=Color(1.0,1.0,1.0,.3)
	else:
		done = false
		$LineEdit.modulate=Color(1.0,1.0,1.0,1)
	
	father.update_progress()


func _on_Button_pressed():
	father.removeme(self)
