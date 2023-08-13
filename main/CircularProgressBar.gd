extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var labels = '' setget update_label
export var progress= 0.0 setget update_progress
var targetprogress = 0.0
onready var TEXT_CONTAINER = $CenterContainer/VBoxContainer/PanelContainer
onready var PROGRESS_BAR = $CenterContainer/TextureProgress
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	run_smoothing()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update_label(new_label):
	$Label.text = new_label


func update_progress(new_progress):
	targetprogress = new_progress
	set_physics_process(true)

func run_smoothing():
	PROGRESS_BAR.value += ((targetprogress-PROGRESS_BAR.value)/50)
	set_physics_process(!(abs(PROGRESS_BAR.value-targetprogress) < 1))
	PROGRESS_BAR.value += (targetprogress-PROGRESS_BAR.value)*int((abs(PROGRESS_BAR.value-targetprogress) < 1))
	TEXT_CONTAINER.text = str(round(PROGRESS_BAR.value))
