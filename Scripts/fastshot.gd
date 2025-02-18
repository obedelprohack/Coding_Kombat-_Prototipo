extends CharacterBody2D # Extendemos la clase "CharacterBody2D"
class_name fastshot # Nombre de esta clase

@onready var animaciones = get_node("AnimationPlayer") # Iniciamos las animaciones
var velocidad = Vector2()  # La velocidad de la bala es igual a "Vector2()"
var dano = 20

func _ready(): #funcion "listo"
	animaciones.play("fastshot")
	
	
	
func set_direccion(dir): #funcion para asignar la direccion de movimiento con el paerametro "dir1" 
	velocidad = dir.normalized() * 300 #"velocidad1" es igual a ala direccion direccion normalizada multipliada por 300
	
	
	
#delta: tiempo transcurrido en seg, desde la llamada anterior ala funcion "proceso"
func _physics_process(delta):
	position += velocidad * delta
	var collision = move_and_collide(velocidad * delta)
	if collision:
		var enemigo = collision.get_collider()
		if enemigo and enemigo.has_method("recibir_dano"):
			enemigo.recibir_dano(dano)
		queue_free()
