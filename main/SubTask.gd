extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var done = false
var father
var mint = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mint=$LineEdit.rect_min_size.y
	

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		done = true
		$LineEdit.modulate=Color(1.0,1.0,1.0,.3)
		$LineEdit.readonly=true
		$LineEdit.rect_min_size.y=mint
	else:
		done = false
		$LineEdit.modulate=Color(1.0,1.0,1.0,1)
		$LineEdit.readonly=false
		_on_LineEdit_text_changed()
	father.update_progress()


func _on_Button_pressed():
	father.removeme(self)




func _on_LineEdit_text_changed():
	$LineEdit.rect_min_size.y=mint+($LineEdit.get_total_visible_rows())*29-25
