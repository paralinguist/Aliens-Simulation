extends Node2D
@export var draw_position = Vector2(0,0)
@export var radius = 100
@export var start_angle = PI*-1
@export var end_angle = 0
@export var points = 180
@export var color = Color(0,0,128,0)
func draw_circle_arc_poly(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color) -> void:
    var points_arc: PackedVector2Array = PackedVector2Array()
    points_arc.push_back(center)
    var colors: PackedColorArray = PackedColorArray([color])

    for i: int in range(point_count + 1):
        var angle_point: float = start_angle + i * (end_angle - start_angle) / point_count
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)

func _draw():
    draw_circle_arc_poly(draw_position, radius, start_angle, end_angle, points, color)
