extends CharacterBody2D # Extendemos la clase "CharacterBody2D"
class_name fisicas_mj # Nombre de esta clase

@onready var text = get_tree().get_root().get_node("Arena/Salidaa")
@onready var animaciones_mj = get_node("AnimationPlayer")
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
var atacando = false # Variable para controlar si el personaje está atacando

#poder
@export var fs:PackedScene
var fs_disp = false
@export var ps:PackedScene
var ps_disp = false
var not_dano = true


func _ready(): #funcion "listo"
	pass
	
	
	
func _process(_delta):
	GLOBAL.energia_yo = energia
	GLOBAL.salud_yo = salud
	
	
	
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
		if cuerpo.is_in_group("xdxdop"):
			var distancia = cuerpo.global_position.distance_to(global_position)
			if distancia < 45:
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
			animaciones_mj.speed_scale = 1.0
			animaciones_mj.play("Jump_mj") # Reproduce la animación de salto
			saltando = true # Marca que el personaje está saltando
	else: #sino 
		saltando = false # Resetea la variable cuando el personaje toca el suelo
		if saltosadar > 0: #si saltosadar es mayor a 0
			velocity.y = velocidadDeSalto  #la velocidad vertical sera igual a la velocidaddesalto
			saltosadar -= 1  # Decrementa la cantidad de saltos que el personaje tiene por dar
		elif velocity.x != 0 and not atacando: # Si el personaje se está moviendo y no está atacando
			animaciones_mj.speed_scale = 1.0
			animaciones_mj.play("Walk_mj") # Reproduce la animación de caminar
		elif not atacando: # Si el personaje está quieto y no está atacando
			animaciones_mj.speed_scale = 1.0
			animaciones_mj.play("Idle_mj") # Reproduce la animación de estar quieto

	if not is_on_floor(): # Si el personaje no está en el suelo,
		velocity.y += gravedad * delta #le sumamos y asignamos el resultado de la gravedad multiplicado por delta a la velocidad vertical
	if is_on_floor() and pasosDados >= pasoadar: #si el personaje esta en el suelo y los pasosdados son mayores o iguales a los pasosadar
		velocity.x = 0  #la velocidad horizontal es igual a 0
		pasosDados = 0  #pasos dados es igual a 0
	else: #sino
		pasosDados += abs(velocity.x) * delta #le asignamos a la variable "pasosDados" 
		#el valor completo y positivo de la "velocidad horizontal" multiplicado por "delta"
	move_and_slide() 
			
			
			
func walk_derecha(pasosDer): # Función para mover el personaje hacia la derecha con la cantidad de pasos especificada en el parametro
	atacando = false
	print("mi personaje dio ", pasosDer, " pasos hacia la derecha")
	direccion = 1 #la direccion es igual a 1 osea la derecha
	pasoadar = pasosDer * paso #pasosadar es igual al parametro multiplicado por "paso"
	velocity.x = rapidez * direccion #velocidad horizontal es igual a "rapidez" por "direccion"
	
	salida("", "", " pasos hacia la derecha", Color(1, 0, 1, 1))
	text.newline()  # Agrega una nueva línea
	
	
	
func walk_izquierda(pasosIzq):# Función para mover el personaje hacia la izquierda con la cantidad de pasos especificada en el parametro
	atacando = false
	print("mi personaje dio ", pasosIzq, " pasos hacia la izquierda")
	direccion = -1 #la direccion es igual a -1 osea la izquierda
	pasoadar = pasosIzq * paso #pasosadar es igual al parametro multiplicado por "paso"
	velocity.x = rapidez * direccion #velocidad horizontal es igual a "rapidez" por "direccion"
	
	salida("", "", " pasos hacia la izquierda", Color(1, 0, 1, 1))
	text.newline()  # Agrega una nueva línea
	
	
	
func saltar(saltos): #funcion para hacer que el personaje salte la cantidad de saltos especificada en el parametro
	if is_on_floor() and saltosadar == 0: #si el perosnaje esta en el suelo y "saltosadar" es igual a 0
		print("mi personaje dio ", saltos, " saltos")
		saltosadar = saltos #"saltosadar" es igual al parametro
		
		salida("", "", " saltos", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
		
	
	
func spin(): #funcion del golpe spin
	animaciones_mj.speed_scale = 1.3
	atacando = true
	if energia >= 5: 
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("Spin_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 15
			
		salida("mi pérsonaje utilizo el golpe Spin", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
#SE DESBLOQUEA CUANDO: 
func powerShot():
	if Ps:
		animaciones_mj.speed_scale = 1.3
		print("mi personaje utilizo el golpe PowerShot")
		atacando = true
		if energia >= 50:
			animaciones_mj.speed_scale = 1.4
			animaciones_mj.play("PowerShot_mj")
			await animaciones_mj.animation_finished  # Espera hasta que la animación termine
		
			var marcador = marcadorIz if get_node("AnimatedSprite2D").flip_h else marcadorDe
			var newposho = ps.instantiate()
			get_parent().add_child(newposho)
			newposho.global_position = marcador.global_position
			newposho.set_direccion(Vector2(-1 if get_node("AnimatedSprite2D").flip_h else 1, 0))
		
			ENERGIA_MJ_GLOBAL.perder_energia(50)
			print("la energia ahora es ", energia)
			ENERGIA_MJ_GLOBAL.recuperar_energia()
			fs_disp = false
			animaciones_mj.speed_scale = 1.0
			animaciones_mj.play("Idle_mj")  # Cambia a la animación Idle
			atacando = false
		
			salida("mi pérsonaje utilizo el golpe PowerShot", "", "", Color(1, 0, 1, 1))
			text.newline()  # Agrega una nueva línea
	
	
	
func fastShot(): #funcion del golpe
	animaciones_mj.speed_scale = 1.3
	print("mi pérsonaje utilizo el golpe FastShot")
	atacando = true
	if energia >= 10:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("FastShot_mj")
		await animaciones_mj.animation_finished  # Espera hasta que la animación termine
		
		var marcador = marcadorIz if get_node("AnimatedSprite2D").flip_h else marcadorDe #creamos una vbariable de un marcador unico, si el jugador mira ala izquierda marcador sera igual a marcadorIz y sino sera igual a marcadorDE
		var newfasho = fs.instantiate() #instancia de la ecena del proyectil 
		get_parent().add_child(newfasho)
		newfasho.global_position = marcador.global_position #la bala tendra la posicion en la que esta el marcador unico
		newfasho.set_direccion(Vector2(-1 if get_node("AnimatedSprite2D").flip_h else 1, 0)) #le asignamos un valor al parametro de la funcion "set_direccion" por medio de la instancia de la ecenas del proyectil
		
		ENERGIA_MJ_GLOBAL.perder_energia(10)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		fs_disp = false
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")  # Cambia a la animación Idle
		atacando = false
		
		salida("mi pérsonaje utilizo el golpe FastShot", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
func flyingKick(): #funcion del golpe
	animaciones_mj.speed_scale = 1.3
	print("mi pérsonaje utilizo el golpe FliyingKick")
	atacando = true
	if energia >= 15:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("FlyingKick_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(15)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 15
			
		salida("mi pérsonaje utilizo el golpe FliyingKick", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
#SE DESBLOQUEA CUANDO: 
func superHuppercut():
	if Sh:
		animaciones_mj.speed_scale = 1.3
		print("mi pérsonaje utilizo el golpe SuperHuppercut")
		atacando = true
		if energia >= 40:
			animaciones_mj.speed_scale = 1.4
			animaciones_mj.play("SuperHuppercut_mj")
			await animaciones_mj.animation_finished
			ENERGIA_MJ_GLOBAL.perder_energia(40)
			print("la energia ahora es ", energia)
			ENERGIA_MJ_GLOBAL.recuperar_energia()
			animaciones_mj.speed_scale = 1.0
			animaciones_mj.play("Idle_mj")
			atacando = false
			golpe = true
		
			if dis:
				danoo = 30
			
			salida("mi pérsonaje utilizo el golpe SuperHuppercut", "", "", Color(1, 0, 1, 1))
			text.newline()  # Agrega una nueva línea
	
	
	
func oneTwoCombo(): #funcion del golpe
	animaciones_mj.speed_scale = 1.3
	print("mi pérsonaje utilizo el golpe OneTwoCombo")
	atacando = true
	if energia >= 10:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("OneTwoCombo_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(10)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 20
			
		salida("mi pérsonaje utilizo el golpe OneTwoCombo", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
func lowKick(val): #funcion del golpe
	print("mi pérsonaje utilizo el golpe LowKick")
	atacando = true
	if energia >= 5:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("Lowkick_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = val
			
		salida("mi pérsonaje utilizo el golpe Lowkick", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
func middleKick(val): #funcion del golpe
	print("mi pérsonaje utilizo el golpe MiddleKick")
	atacando = true
	if energia >= 5:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("MiddleKick_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = val
			
		salida("mi pérsonaje utilizo el golpe MiddleKick", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
func highKick(val): #funcion del golpe
	print("mi pérsonaje utilizo el golpe HighKick")
	atacando = true
	if energia >= 5:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("HighKick_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = val
			
		salida("mi pérsonaje utilizo el golpe HighKick", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
#SE DESBLOQUEA CUANDO: 
func lmhKick():
	if LmhK:
		lowKick(15)
		await get_tree().create_timer(0.3).timeout
		middleKick(15)
		await get_tree().create_timer(0.3).timeout
		highKick(15)
	
	
	
func huppercut(): #funcion del golpe
	print("mi pérsonaje utilizo el golpe Huppercut")
	atacando = true
	if energia >= 15:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("Huppercut_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(15)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 20
			
		salida("mi pérsonaje utilizo el golpe Huppercut", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
func cover(): #funcion del golpe
	print("mi pérsonaje se a cubierto")
	atacando = true
	animaciones_mj.speed_scale = 1.4
	animaciones_mj.play("Cover_mj")
	await animaciones_mj.animation_finished  # Espera hasta que la animación termine
	not_dano = false
	await get_tree().create_timer(5).timeout  # Pausa por 10 segundos
	animaciones_mj.speed_scale = 1.4
	animaciones_mj.play_backwards("Cover_mj")  # Reproduce la animación en reversa
	await animaciones_mj.animation_finished  # Espera hasta que la animación termine
	not_dano = true
	animaciones_mj.speed_scale = 1.0
	animaciones_mj.play("Idle_mj")  # Cambia a la animación Idle
	atacando = false
	
	salida("mi pérsonaje se a cubierto", "", "", Color(1, 0, 1, 1))
	text.newline()  # Agrega una nueva línea
	
	
	
func punch(): #funcion del golpe
	print("mi pérsonaje a dado un golpe Punch")
	atacando = true
	if energia >= 5:
		animaciones_mj.speed_scale = 1.4
		animaciones_mj.play("Punch_mj")
		await animaciones_mj.animation_finished
		ENERGIA_MJ_GLOBAL.perder_energia(5)
		print("la energia ahora es ", energia)
		ENERGIA_MJ_GLOBAL.recuperar_energia()
		animaciones_mj.speed_scale = 1.0
		animaciones_mj.play("Idle_mj")
		atacando = false
		golpe = true
		
		if dis:
			danoo = 5
			
		salida("mi pérsonaje utilizo el golpe Punch", "", "", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
	
	
	
func recibir_dano(dano):
	if not_dano:
		atacando = true
		salud -= dano
		salida("mi jugador recibio ", dano, " de daño", Color(1, 0, 1, 1))
		text.newline()  # Agrega una nueva línea
		if dano == 30:
			nockout()
			salida("mi jugador a sido noqueado ", "", "", Color(1, 0, 1, 1))
			text.newline()  # Agrega una nueva línea
		if salud <= 0:
			GLOBAL.stop = true
			colision.rotation_degrees = 90
			colisionA.rotation_degrees = 90
			animaciones_mj.speed_scale = 1.4
			animaciones_mj.play("Dead_mj")
			await animaciones_mj.animation_finished
			animaciones_mj.play("Tumba_mj")
			await animaciones_mj.animation_finished
			atacando = false
			get_tree().change_scene_to_file("res://Ecenas/gameover.tscn")
		
		
		
func stop():
	velocity.x = 0  # Detiene el movimiento horizontal
	saltosadar = 0
	velocity.y = 0  # Detiene el movimiento vertical
	pasoadar = 0
	animaciones_mj.speed_scale = 1.0
	animaciones_mj.play("Idle_mj")  # Reproduce la animación de estar quieto
	
	salida("mi pérsonaje a detenido toda sus acciones", "", "", Color(1, 0, 1, 1))
	text.newline()  # Agrega una nueva línea
		
		
		
func nockout():
	colision.rotation_degrees = 90
	animaciones_mj.play("Dead_mj")
	await get_tree().create_timer(2.5).timeout
	colision.rotation_degrees = 0
	animaciones_mj.play_backwards("Dead_mj")
	animaciones_mj.play("Idle_mj")
	
	
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("xdxdop"):
		pass
		
		
		
# En tu escena 'mijugador'
func salida(tex, tex0, text1, color):
	var texto = tex + str(tex0) + text1
	text.push_color(color)  # Cambia el color
	text.add_text(texto)
	text.pop()  # Restaura el color original
