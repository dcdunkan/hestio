extends Block
class_name Brick

@onready var sprite_2d = $Sprite2D
@onready var gpu_particles_2d = $GPUParticles2D

func bump():
	super.bump()
