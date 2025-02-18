extends CharacterBody2D # Extendemos la clase "CharacterBody2D"
class_name fisicas_op # Nombre de esta clase


@onready var animaciones_op = get_node("AnimationPlayer")
@onready var enSuelo : bool = false
@onready var animacionplay: bool = false

@onready var marcadorIz = get_node("Marker2DIz")
@onready var marcadorDe = get_node("Marker2DDe")

var energia = 120
var salud = 120

@onready var colision = get_node("CollisionShape2D")
@onready var colisionA = get_node("Area2D/CollisionShape2D")

var dis = false
var golpe = false
var danoo = 0

var Ps = false
var Sh = false
var LmhK = false


#fisicas
var ppm : int = 24 # Píxeles por metro (unidades del juego)
var direccion : float # Dirección de movimiento del personaje
@onready var gravedad : float = 15 * ppm #la gravedad es igual a 15 multiplicado por la variable ppm
@onready var rapidez = 200.0 # Rapidez de movimiento del personaje

#Caminar
var pasosDados = 0 #variable que cuenta los pasos dados
const paso = 70.0 # un paso es igual a 70.0
var pasoadar = 0 #pasos que el jugador a asignado 

#Saltarla 
const velocidadDeSalto = -500.0 #velocidad de salto que es inalterable
var saltosadar = 0 #saltos que el jugador a asignado
var saltando = false
var atacando = false

#poder
@export var fs:PackedScene
var fs_disp = false
@export var ps:PackedScene
var ps_disp = false
var not_dano = true


func _ready():
	pass
	
	
	
func _process(_delta):
	GLOBAL.energia_oponente = energia
	GLOBAL.salud_oponente = salud
	
	
	
#delta: tiempo transcurrido en seg, desde la llamada anterior ala funcion "proceso"
func _physics_process(delta):#funcion "proceso de las fisicas" con el parametro "delta" de esta clase
	if direccion > 0:
		#derecha
		get_node("AnimatedSprite2D").flip_h = false
		
	elif direccion < 0:
		#izquierda
		get_node("AnimatedSprite2D").flip_h = true
		
	var cuerpos = get_node("Area2D").get_overlapping_bodies() 
	for cuerpo in cuerpos:
		if cuerpo.is_in_group("xdxdmj"):
			
			var distancia = cuerpo.global_position.distance_to(global_position)
			
			if distancia < 45:  # Reemplaza 'cierta_distancia' con la distancia que consideres 'cerca'
				dis = true
				cuerpo.recibir_dano(danoo) 
				danoo = 0
				golpe = false
			else:
				dis = false
				golpe = false
				
	if not is_on_floor(): # Si el personaje no está en el suelo
		velocity.y += gravedad * delta  #le sumamos y asignamos el resultado de la gravedad multiplicado por delta a la velocidad vertical
		if not saltando and not atacando: # Si el personaje no está saltando
			animaciones_op.speed_scale = 1.0
			animaciones_op.play("Jump_op") # Reproduce la animación de salto
			saltando = true # Marca que el personaje está saltando
	else: #sino 
		saltando = false # Resetea la variable cuando el personaje toca el suelo
		if saltosadar > 0: #si saltosadar es mayor a 0
			velocity.y = velocidadDeSalto  #la velocidad vertical sera igual a la velocidaddesalto
			saltosadar -= 1  # Decrementa la cantidad de saltos que el personaje tiene por dar
		elif velocity.x != 0 and not atacando: # Si el personaje se está moviendo y no está atacando
			animaciones_op.speed_scale = 1.0
			animaciones_op.play("Walk_op") # Reproduce la animación de caminar
		elif not atacando: # Si el personaje está quieto y no está atacando
			animaciones_op.speed_scale = 1.0
			animaciones_op.play("Idle_op") # Reproduce la animación de estar quieto

	if not is_on_floor(): # Si el personaje no está en el suelo,
		velocity.y += gravedad * delta #le sumamos y asignamos el resultado de la gravedad multiplicado por delta a la velocidad vertical
	if is_on_floor() and pasosDados >= pasoadar: #si el personaje esta en el suelo y los pasosdados son mayores o iguales a los pasosadar
		velocity.x = 0  #la velocidad horizontal es igual a 0
		pasosDados = 0  #pasos dados es igual a 0
	else: #sino
		pasosDados += abs(velocity.x) * delta #le asignamos a la variable "pasosDados" 
		#el valor completo y positivo de la "velocidad horizontal" multiplicado por "delta"
	move_and_slide() 
			
			
			
func walk_derecha(pasosDer): # Función para mover el personaje hacia la derecha con la cantidad de pasos especificada en el parametr
	atacando = false
	print("el oponente dio ", pasosDer, " pasos hacia la derecha")
	direccion = 1 #la direccion es igual a 1 osea la derecha
	pasoadar = pasosDer * paso #pasosadar es igual al parametro multiplicado por "paso"
	velocity.x = rapidez * direccion #velocidad horizontal es igual a "rapidez" por "direccion"
	
	
	
func walk_izquierda(pasosIzq):# Función para mover el personaje hacia la izquierda con la cantidad de pasos especificada en el parametro
	atacando = false
	print("el oponente dio ", pasosIzq, " pasos hacia la izquierda")
	direccion = -1 #la direccion es igual a -1 osea la izquierda
	pasoadar = pasosIzq * paso #pasosadar es igual al parametro multiplicado por "paso"
	velocity.x = rapidez * direccion #velocidad horizontal es igual a "rapidez" por "direccion"
	
	
	
func saltar(saltos): #funcion para hacer que el personaje salte la cantidad de saltos especificada en el parametro
	if is_on_floor() and saltosadar == 0: #si el perosnaje esta en el suelo y "saltosadar" es igual a 0
		print("el oponente dio ", saltos, " saltos")
		saltosadar = saltos #"saltosadar" es igual al parametro
	
	
	
func spin(): #funcion del golpe spin
	print("el oponente utilizo el golpe Spin")
	atacando = true
	if energia >= 5: 
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("Spin_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 15
	
	
	
#SE DESBLOQUEA CUANDO: 
func powerShot():
	if Ps:
		print("el oponente utilizo el golpe PowerShot")
		atacando = true
		if energia >= 50:
			animaciones_op.speed_scale = 1.4
			animaciones_op.play("PowerShot_op")
			await animaciones_op.animation_finished  # Espera hasta que la animación termine
		
			var marcador = marcadorIz if get_node("AnimatedSprite2D").flip_h else marcadorDe
			var newposho = ps.instantiate()
			get_parent().add_child(newposho)
			newposho.global_position = marcador.global_position
			newposho.set_direccion(Vector2(-1 if get_node("AnimatedSprite2D").flip_h else 1, 0))
		
			ENERGIA_OP_GLOBAL.perder_energia(50)
			print("la energia ahora es ", energia)
			ENERGIA_OP_GLOBAL.recuperar_energia()
			fs_disp = false
			animaciones_op.speed_scale = 1.0
			animaciones_op.play("Idle_op")  # Cambia a la animación Idle
			atacando = false
	
	
	
func fastShot(): #funcion del golpe
	print("el oponente utilizo el golpe FastShot")
	atacando = true
	if energia >= 10:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("FastShot_op")
		await animaciones_op.animation_finished  # Espera hasta que la animación termine
		
		var marcador = marcadorIz if get_node("AnimatedSprite2D").flip_h else marcadorDe #creamos una vbariable de un marcador unico, si el jugador mira ala izquierda marcador sera igual a marcadorIz y sino sera igual a marcadorDE
		var newfasho = fs.instantiate() #instancia de la ecena del proyectil 
		get_parent().add_child(newfasho)
		newfasho.global_position = marcador.global_position #la bala tendra la posicion en la que esta el marcador unico
		newfasho.set_direccion(Vector2(-1 if get_node("AnimatedSprite2D").flip_h else 1, 0)) #le asignamos un valor al parametro de la funcion "set_direccion" por medio de la instancia de la ecenas del proyectil
		
		ENERGIA_OP_GLOBAL.perder_energia(10)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		fs_disp = false
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")  # Cambia a la animación Idle
		atacando = false
	
	
	
func flyingKick(): #funcion del golpe
	print("el oponente utilizo el golpe FliyingKick")
	atacando = true
	if energia >= 15:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("FlyingKick_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(15)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 15
	
	
	
#SE DESBLOQUEA CUANDO: 
func superHuppercut():
	if Sh:
		print("el oponente utilizo el golpe SuperHuppercut")
		atacando = true
		if energia >= 40:
			animaciones_op.speed_scale = 1.4
			animaciones_op.play("SuperHuppercut_op")
			await animaciones_op.animation_finished
			ENERGIA_OP_GLOBAL.perder_energia(40)
			print("la energia ahora es ", energia)
			ENERGIA_OP_GLOBAL.recuperar_energia()
			animaciones_op.speed_scale = 1.
			animaciones_op.play("Idle_op")
			atacando = false
			golpe = true
		
			if dis:
				danoo = 30
	
	
	
func oneTwoCombo(): #funcion del golpe
	print("el oponente utilizo el golpe OneTwoCombo")
	atacando = true
	if energia >= 10:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("OneTwoCombo_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(10)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 20
	
	
	
func lowKick(val): #funcion del golpe
	print("el oponente utilizo el golpe LowKick")
	atacando = true
	if energia >= 5:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("Lowkick_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = val
	
	
	
func middleKick(val): #funcion del golpe
	print("el oponente utilizo el golpe MiddleKick")
	atacando = true
	if energia >= 5:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("MiddleKick_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = val
	
	
	
func highKick(val): #funcion del golpe
	print("el oponente utilizo el golpe HighKick")
	atacando = true
	if energia >= 5:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("HighKick_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = val
			
			
			
#SE DESBLOQUEA CUANDO: 
func lmhKick():
	if LmhK:
		lowKick(15)
		await get_tree().create_timer(0.2).timeout
		middleKick(15)
		await get_tree().create_timer(0.2).timeout
		highKick(15)
	
	
	
func huppercut(): #funcion del golpe
	print("el oponente utilizo el golpe Huppercut")
	atacando = true
	if energia >= 15:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("Huppercut_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(15)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 20
	
	
	
func cover(): #funcion del golpe
	print("el oponente se a cubierto")
	atacando = true
	animaciones_op.speed_scale = 1.4
	animaciones_op.play("Cover_op")
	await animaciones_op.animation_finished  # Espera hasta que la animación termine
	not_dano = false
	await get_tree().create_timer(5).timeout  # Pausa por 10 segundos
	animaciones_op.speed_scale = 1.4
	animaciones_op.play_backwards("Cover_op")  # Reproduce la animación en reversa
	await animaciones_op.animation_finished  # Espera hasta que la animación termine
	not_dano = true
	animaciones_op.speed_scale = 1.0
	animaciones_op.play("Idle_op")  # Cambia a la animación Idle
	atacando = false
	
	
	
func punch(): #funcion del golpe
	print("el oponente a dado un golpe Punch")
	atacando = true
	if energia >= 5:
		animaciones_op.speed_scale = 1.4
		animaciones_op.play("Punch_op")
		await animaciones_op.animation_finished
		ENERGIA_OP_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_OP_GLOBAL.recuperar_energia()
		animaciones_op.speed_scale = 1.0
		animaciones_op.play("Idle_op")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 5
	
	
	
func recibir_dano(dano):
	if not_dano:
		atacando = true
		salud -= dano
		if dano == 30:
			nockout()
		if salud <= 0:
			GLOBAL.stop = true
			colision.rotation_degrees = 90
			animaciones_op.play("Dead_op")
			await animaciones_op.animation_finished
			animaciones_op.play("Tumba_op")
			colisionA.rotation_degrees = 90
			await animaciones_op.animation_finished
			
			get_tree().change_scene_to_file("res://Ecenas/gameover.tscn")
		
		
		
func stop():
	velocity.x = 0  # Detiene el movimiento horizontal
	saltosadar = 0
	velocity.y = 0  # Detiene el movimiento vertical
	pasoadar = 0
	animaciones_op.speed_scale = 1.0
	animaciones_op.play("Idle_op")  # Reproduce la animación de estar quieto
	
	
	
func nockout():
	colision.rotation_degrees = 90
	animaciones_op.play("Dead_op")
	await get_tree().create_timer(2.5).timeout
	colision.rotation_degrees = 0
	animaciones_op.play_backwards("Dead_op")
	animaciones_op.play("Idle_op")
	
	
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("xdxdmj"):
		pass
