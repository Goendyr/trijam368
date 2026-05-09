class_name BabySpawner
extends Node3D

@export var spawn_area: int = 100
@export var spawn_probability: float = 0.1


var baby: PackedScene = preload("res://baby.tscn")


func _ready() -> void:
	for i: int in spawn_area:
		for j: int in spawn_area:
			if randf() < spawn_probability:
				spawn_baby(Vector3(i - spawn_area / 2.0, 0.0, j - spawn_area / 2.0))


func spawn_baby(pos: Vector3) -> void:
	var baby_scene: Node3D = baby.instantiate()
	self.add_child(baby_scene)
	baby_scene.global_position = pos
