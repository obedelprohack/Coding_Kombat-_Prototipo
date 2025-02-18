extends Node2D
class_name arena


@onready var text = $Salidaa#salida de algun comando
var iniciar = false
var segundos = 00
var minutos = 00
var stop_anterior = false  # Variable para almacenar el estado anterior de GLOBAL.stop

#mi jugador
var scene_mi_jugador = preload("res://Ecenas/mi_jugador.tscn")
@onready var consola_mijugador = $Consola_MJ
var mijugador
var comandos_mijugador

#oponente
var scene_oponente = preload("res://Ecenas/oponente.tscn")
@onready var consola_oponente = $Consola_OP
var eloponente
var comandos_oponente
var texto_anterior


func _ready():#funcion ready
	multiplayer.server_disconnected.connect(desconectado)
	
	#mi jugador
	ENERGIA_MJ_GLOBAL.visible_in_this_scene = true
	VIDA_MJ_GLOBAL.visible_in_this_scene = true
	mijugador = scene_mi_jugador.instantiate()
	mijugador.global_position = Vector2(1200, 500)
	add_child(mijugador)
	
	#oponentes
	ENERGIA_OP_GLOBAL.visible_in_this_scene = true
	VIDA_OP_GLOBAL.visible_in_this_scene = true
	eloponente = scene_oponente.instantiate()
	eloponente.global_position = Vector2(300, 500)
	add_child(eloponente)
	
	
	
	
func _process(_delta): #funcion "procesos"
	if Input.is_action_just_pressed("ejecutar"): #si la accion "ejecutar" del teclado es presionada
		_on_ejecutar_mj_pressed() #seZ ejecuta la funcion "_on_ejecutar_pressed"
		
	if Input.is_action_just_pressed("salida"): #si la accion "ejecutar" del teclado es presionada
		_on_cambio_pressed()
		
	# Verifica si hay texto nuevo en la consola del oponente
	if consola_oponente.text != texto_anterior:
		texto_anterior = consola_oponente.text
		_on_ejecutar_op_pressed()
		
	if not iniciar:
		mensajes_recibidos.rpc_id(GLOBAL.id_oponente, "READYFUCK")
	
	
	
func desconectado():#cuando yo me desconecto
	multiplayer.multiplayer_peer = null 
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Ecenas/menu.tscn")
	
	
	
@rpc("any_peer")#recibir los mensajes del oponente
func mensajes_recibidos(message: String):
	print("mensaje recibido: ", message)
	if message == "READYFUCK":
		iniciar = true
		consola_oponente.clear()
	else:
		consola_oponente.clear()
		await get_tree().create_timer(0.1).timeout
	
		# Cambia 'WalkRight' a 'WalkLeft' y viceversa
		if "WalkRight" in message:
			message = message.replace("WalkRight", "WalkLeft")
		elif "WalkLeft" in message:
			message = message.replace("WalkLeft", "WalkRight")
	
		consola_oponente.text += message + "\n"  # Añade el mensaje recibido al TextEditRe.
	
	
	
func _on_ejecutar_mj_pressed():#ejecutar mis comandos
	comandos_mijugador = consola_mijugador.text.split("\n")
	print(comandos_mijugador)
	
	text.newline()  # Agrega una nueva línea
	text.newline()  # Agrega una nueva línea
	text.add_text("EJECUTAR A SIDO PRESIONADO¡¡¡")
	text.pop()  # Restaura el color original
	text.newline()  # Agrega una nueva línea
	
	mijugador.ejecutar_comandos(comandos_mijugador)
	mijugador.ejecutar = true
	
	
	for mensaje in comandos_mijugador:  # Itera sobre cada mensaje en 'mensajes_enviados'.
		mensajes_recibidos.rpc_id(GLOBAL.id_oponente, mensaje)  # Envía cada mensaje al servidor.
	
	
	
func _on_ejecutar_op_pressed():#ejecutar comandos del oponente
	comandos_oponente = consola_oponente.text.split("\n")
	eloponente.ejecutar_comandos(comandos_oponente)
	eloponente.ejecutar = true
	
	
	
func _on_cambio_pressed():#mostrar la salida
	text.visible = !text.visible
	
	
	
func _on_timer_timeout():
	if not GLOBAL.stop:
		if iniciar:
			segundos += 1
			if segundos >= 60:
				minutos += 1
				segundos = 0
			$Time.text = str(minutos) + ":" + str(segundos).pad_zeros(2)
	else:
		if not stop_anterior:  # Si GLOBAL.stop acaba de cambiar a true
			GLOBAL.tiempo = str(minutos) + ":" + str(segundos).pad_zeros(2)
	stop_anterior = GLOBAL.stop  # Actualiza el estado anterior de GLOBAL.stop
