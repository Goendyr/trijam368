extends Node3D


func explode() -> void:
	%Splatter.restart()
	%Boom.restart()
	%Smoke.restart()
	$CarCrashSound.play()
