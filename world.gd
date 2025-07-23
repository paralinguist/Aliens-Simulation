extends Node2D
var shields_up = false
var shields_target = 0
var shields_level = 0
var registered = false
var username = "clarence"
var pin = 0
var logged_in = false
var stage = 1
var stages = {}
var progress = {}
var progress_file = "progress.json"

func _ready() -> void:
    var stages_file = "stages.json"
    var json_as_text = FileAccess.get_file_as_string(stages_file)
    stages = JSON.parse_string(json_as_text)
    load_progress()
    stage = stage - 1
    advance_stage()

func load_progress():
    var json_as_text = FileAccess.get_file_as_string(progress_file)
    progress = JSON.parse_string(json_as_text)
    stage = int(progress["stage"])
    username = progress["username"]
    pin = int(progress["pin"])
    shields_up = progress["shields_up"]
    shields_target = int(progress["shields_target"])
    shields_level = int(progress["shields_level"])
    set_shields(shields_level)

func save_progress():
    progress["stage"] = stage
    progress["username"] = username
    progress["pin"] = pin
    progress["shields_up"] = shields_up
    progress["shields_target"] = shields_target
    progress["shields_level"] = shields_level
    var json_string = JSON.stringify(progress)
    var progress_file_pointer = FileAccess.open(progress_file, FileAccess.ModeFlags.WRITE)
    progress_file_pointer.store_string(json_string)

func set_shields(power):
    if shields_up:
        $Shield.draw_position = Vector2($Base.position.x, 590)
        $Shield.color = Color(0,0,128,0.5*power/100)
        $Shield.radius = 300
        $Shield.queue_redraw()

func enable_shields():
    shields_up = true

func advance_stage():
    stage = stage + 1
    if stages.has(str(stage)):
        $Panel/LabelHint.text = stages[str(stage)]["hint"]
        $Panel/LabelStage.text = "Stage " + str(stage)
    else:
        $Panel/LabelHint.text = "The aliens have been defeated and have retreated. Diplomatic discussions can begin."
    save_progress()

func _debug_next_stage():
    advance_stage()

func register(new_user, new_pin):
    var result = "Error registering"
    if not registered:
        username = new_user
        pin = new_pin
        registered = true
        advance_stage()
        result = "Successfully registered user " + new_user
    else:
        result = "Already registered!"
    return result
    

func _reset_progress():
    shields_up = false
    shields_target = 0
    shields_level = 0
    registered = false
    username = "clarence"
    pin = 0
    logged_in = false
    stage = 0
    save_progress()
    advance_stage()
