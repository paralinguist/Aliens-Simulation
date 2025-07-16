extends Node2D
var shields_up = false
var registered = false
var username = ""
var pin = 0
var logged_in = false

func _ready() -> void:
    #enable_shields()
    #set_shields(100)
    pass

func set_shields(power):
    print(power)
    if shields_up:
        $Shield.draw_position = Vector2($Base.position.x, 590)
        $Shield.color = Color(0,0,128,0.5*power/100)
        $Shield.radius = 300
        $Shield.queue_redraw()

func enable_shields():
    shields_up = true
