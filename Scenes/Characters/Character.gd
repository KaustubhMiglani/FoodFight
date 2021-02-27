extends KinematicBody

const projectile_speed=50

var food_types={}

var can_fire=true

func _ready():
	food_types=FileGrabber.get_files("res://Projectiles/Food_items/")
	randomize()
func fire():
	var random_food=food_types[randi()%(food_types.size())]
	var projectile=load(random_food).instance()
	add_child(projectile)
	projectile.set_as_toplevel(true)
	projectile.global_transform=$Forward.global_transform
	var character_forward=global_transform.basis[2].normalized()
	projectile.linear_velocity=character_forward*projectile_speed


func try_to_fire():
	if(can_fire):
		fire()
		can_fire=false
		$Timer.start()
func _on_Timer_timeout():
	can_fire=true
