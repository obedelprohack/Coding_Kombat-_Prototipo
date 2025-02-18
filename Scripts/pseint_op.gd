extends fisicas_op
class_name pseint_op

#pseint
var datos_numericos = {} 
var datos_logico = {} 
var datos_caracter = {} 
var datos_operador = ["<", ">", ">=", "<=", "==", "=", "!=", "+=", "-="]
var comandos_un_parametro = ["Jump", "WalkRight", "WalkLeft"]
var comandos_sin_parametro = ["Huppercut", "FastShot", "Spin","SuperHuppercut", "PowerShot", "LowKick", 
"MiddleKick", "HighKick", "Cover", "Punch", "OneTwoCombo", "KickCombo", "Stop", "Right", "Left", "FlyingKick"]

var ejecutar = true

var nombre_comando

var parametro0
var parametro1
var parametro2

var argumento0
var argumento1
var argumento2

var espera = 0


func _ready():
	animaciones_op.play("Idle_op")
	
	
	
func _process(_delta):
	energia = ENERGIA_OP_GLOBAL.energia
	VIDA_OP_GLOBAL.salud = salud
	
	
	
func ejecutar_comandos(comandoss):
	datos_numericos.clear()
	datos_logico.clear()
	datos_caracter.clear()
	nombre_comando = null
	parametro0 = null
	parametro1 = null
	parametro2 = null
	argumento0 = null
	argumento1 = null
	argumento2 = null
	espera = 0
	
	for comandoenvio in comandoss:
		
		if ejecutar:
			if comandoenvio.begins_with("Numerico"):
				interpretar_comando_datN(comandoenvio)
			elif comandoenvio.begins_with("Logico"):
				interpretar_comando_datL(comandoenvio)
			elif comandoenvio.begins_with("Caracter"):
				interpretar_comando_datC(comandoenvio)
			else:
				interpretar_comando_con_parametro(comandoenvio)
		await get_tree().create_timer(espera).timeout
		
		
		
func interpretar_comando_datN(comandorecibido):
	var argumento = comandorecibido.replace("Numerico ", "")
	organizar_datosN(argumento)
	comandorecibido = null
	
	
func interpretar_comando_datL(comandorecibido):
	var argumento = comandorecibido.replace("Logico ", "")
	organizar_datosL(argumento)
	comandorecibido = null
	
	
	
func interpretar_comando_datC(comandorecibido):
	var argumento = comandorecibido.replace("Caracter ", "")
	organizar_datosC(argumento)
	comandorecibido = null
	
	
	
func interpretar_comando_con_parametro(comandorecibido):
	var partes = comandorecibido.split("(") 
	nombre_comando = partes[0] 
	
	if partes.size() > 1: 
		var argumentos = partes[1].replace(")", "").split(" ")
		
		if argumentos.size() > 0:
			argumento0 = argumentos[0]
			buscar_variable0(argumento0)
			print(argumento0)
			
		if argumentos.size() > 1:
			argumento1 = argumentos[1]
			buscar_variable1(argumento1)
			print(argumento1)
			
		if argumentos.size() > 2:
			argumento2 = argumentos[2]
			buscar_variable2(argumento2)
			print(argumento2)
			
			
		match nombre_comando:
			#fisicas
			"WalkRight": 
				walk_derecha(parametro0)
			"WalkLeft": 
				walk_izquierda(parametro0) 
			"Jump":
				saltar(parametro0)
				
			#pseint
			"Si":
				condicional_si(parametro0, parametro1, parametro2)
			"EntoncesSi":
				condicional_entonces_si(parametro0, parametro1, parametro2)
			"Entonces":
				condicional_enonces(parametro0, parametro1, parametro2)
			"Para,Hasta,Hacer":
				bucle_para(parametro0, parametro1, parametro2)
			"Espera":
				esperaa(parametro0)
				
			#otros
			"Print":
				comunicar(str(parametro0))
	else:
		ejecutar_comando_sin_parametro(nombre_comando)
		
		
		
func ejecutar_comando_sin_parametro(nombre_comando_recibido):
	match nombre_comando_recibido: 
		"Spin":
			spin()
		"PowerShot":
			powerShot()
		"FastShot":
			fastShot()
		"FlyingKick":
			flyingKick()
		"SuperHuppercut":
			superHuppercut()
		"OneTwoCombo":
			oneTwoCombo()
		"LowKick": 
			lowKick(5)
		"MiddleKick":
			middleKick(10)
		"HighKick": 
			highKick(15)
		"KickCombo": 
			lmhKick()
		"Huppercut": 
			huppercut()
		"Cover": 
			cover()
		"Punch": 
			punch()
		"Right":
			direccion = 1
		"Left":
			direccion = -1
		"Stop":
			stop()
			
			
			
#DATOS
func is_numeric(s):
	if s == null:
		return false
	var punto = false
	for c in s:
		if c in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']:
			continue
		elif c == '.' and !punto:
			punto = true
		else:
			s = null
			return false
	s = null
	return true
	
	
	
func organizar_datosN(argumento):
	var partes = argumento.split("=")
	if partes.size() == 2:
		var valor_dato = partes[1].strip_edges()
		
		if is_numeric(valor_dato):
			crear_datoN(argumento)
	argumento = null
	
	
	
func crear_datoN(dato):
	var partes = dato.split("=")
	if partes.size() == 2:
		var nombre_datoN = partes[0].strip_edges()
		var valor_datoN = partes[1].strip_edges().to_int()
		
		if nombre_datoN in datos_numericos or nombre_datoN in datos_logico or nombre_datoN in datos_caracter:
			print("Error: El dato " + nombre_datoN + " ya existe.")
		else:
			datos_numericos[nombre_datoN] = valor_datoN
			print("datoN creado: " + nombre_datoN + " = " + str(valor_datoN))
	dato = null
		
		
		
func organizar_datosL(argumento):
	var partes = argumento.split("=")
	if partes.size() == 2:
		var valor_dato = partes[1].strip_edges()
		
		if valor_dato == "true" or valor_dato == "false":
			crear_datoL(argumento)
	argumento = null
			
			
			
func crear_datoL(dato):
	var partes = dato.split("=")
	if partes.size() == 2:
		var nombre_datoL = partes[0].strip_edges() 
		var valor_datoL = partes[1].strip_edges() == "true" and "false"
		
		if nombre_datoL in datos_logico:
			print("el datoL " + nombre_datoL + " ya existe. Se actualizará con el nuevo valor.")
		
		if nombre_datoL in datos_numericos or nombre_datoL in datos_logico or nombre_datoL in datos_caracter:
			print("Error: El dato " + nombre_datoL + " ya existe.")
		else:
			datos_logico[nombre_datoL] = valor_datoL
			print("datoL creada: " + nombre_datoL + " = " + str(valor_datoL))
	dato = null
		
		
		
func organizar_datosC(argumento):
	var partes = argumento.split("=")
	if partes.size() == 2:
			crear_datoC(argumento)
	argumento = null
			
			
			
func crear_datoC(dato):
	var partes = dato.split("=")
	if partes.size() == 2:
		var nombre_datoC = partes[0].strip_edges()
		var valor_datoC = partes[1].strip_edges()
		
		if nombre_datoC in datos_caracter:
			print("el datoC " + nombre_datoC + " ya existe. Se actualizará con el nuevo valor.")
		if nombre_datoC in datos_numericos or nombre_datoC in datos_logico or nombre_datoC in datos_caracter:
			print("Error: El dato " + nombre_datoC + " ya existe.")
		else:
			datos_caracter[nombre_datoC] = valor_datoC
			print("datoC creada: " + nombre_datoC + " = " + str(valor_datoC))
	dato = null
			
		
		
#CONDICIONES
func condicional_si(condicion_p1, operdador, condicion_p2):
	print(condicion_p1, operdador, condicion_p2)
	if operdador == ">":
		mayor_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "<":
		menor_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "==":
		igual_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "<=":
		menor_o_igual_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == ">=":
		mayor_o_igual_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "!=":
		distinto_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	
	
	
func condicional_entonces_si(condicion_p1, operdador, condicion_p2):
	print(condicion_p1, operdador, condicion_p2)
	if operdador == ">":
		mayor_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "<":
		menor_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "==":
		igual_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "<=":
		menor_o_igual_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == ">=":
		mayor_o_igual_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "!=":
		distinto_que(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	
	
	
func condicional_enonces(condicion_p1, operdador, condicion_p2):
	print(condicion_p1, operdador, condicion_p2)
	if condicion_p1 in comandos_sin_parametro and operdador == null and condicion_p2 == null:
		ejecutar_comando_sin_parametro(condicion_p1)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "=":
		asignacion(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "+=":
		adicion(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	elif operdador == "-=":
		sustraccion(condicion_p1, condicion_p2)
		condicion_p1 = null
		operdador = null
		condicion_p2 = null
	
	
	
#OPERADORES
func mayor_que(dat1, dat2):
	if dat1 > dat2:
		print("true")
		ejecutar =  true
	else:
		print("false")
		ejecutar = false
	dat1 = null
	dat2 = null
	
	
	
func menor_que(dat1, dat2):
	if dat1 < dat2:
		print("true")
		ejecutar = true
	else:
		print("false")
		ejecutar = false
	dat1 = null
	dat2 = null
	
	
	
func igual_que(dat1, dat2):
	if dat1 == dat2:
		print("true")
		ejecutar = true
	else:
		print("false")
		ejecutar = false
	dat1 = null
	dat2 = null
	
	
	
func mayor_o_igual_que(dat1, dat2):
	if dat1 >= dat2:
		print("true")
		ejecutar = true
	else:
		print("false")
		ejecutar = false
	dat1 = null
	dat2 = null
	
	
	
func menor_o_igual_que(dat1, dat2):
	if dat1 <= dat2:
		print("true")
		ejecutar = true
	else:
		print("false")
		ejecutar = false
	dat1 = null
	dat2 = null
	
	
	
func distinto_que(dat1, dat2):
	if dat1 != dat2:
		print("true")
		ejecutar = true
	else:
		print("false")
		ejecutar = false
	dat1 = null
	dat2 = null
		
		
		
func asignacion(dat1, dat2):
	if dat2 in datos_numericos:
		dat2 = datos_numericos[dat2]
	elif dat2 in datos_caracter:
		dat2 = datos_caracter[dat2]
	elif dat2 in datos_logico:
		dat2 = datos_logico[dat2]
	elif is_numeric(dat2):
		dat2 = dat2.to_int()
	else:
		dat2 = dat2
		
	if dat1 in datos_numericos:
		datos_numericos[dat1] = dat2
		print(datos_numericos[dat1])
		
	elif dat1 in datos_caracter:
		datos_caracter[dat1] = dat2
		print(datos_caracter[dat1])
		
	elif dat1 in datos_logico:
		if str(dat2) == "true" or str(dat2) == "false" or dat2 in datos_logico:
			datos_logico[dat1] = dat2
			print(datos_logico[dat1])
		else:
			print("El valor no es lógico")
	else:
		print("No existe la variable: ", dat1,)
	dat1 = null
	dat2 = null
	
	
	
func sustraccion(dat1, dat2):
	if dat2 in datos_numericos:
		dat2 = datos_numericos[dat2]
	elif is_numeric(dat2):
		dat2 = dat2.to_int()
	else:
		return
		
	if dat1 in datos_numericos:
		datos_numericos[dat1] -= dat2
		print(datos_numericos[dat1])
	else:
		print("No existe la variable: ", dat1)
	dat1 = null
	dat2 = null
	
	
	
func adicion(dat1, dat2):
	if dat2 in datos_numericos:
		dat2 = datos_numericos[dat2]
	elif is_numeric(dat2):
		dat2 = dat2.to_int()
	else:
		return
	if dat1 in datos_numericos:
		datos_numericos[dat1] += dat2
		print(datos_numericos[dat1])
	else:
		print("No existe la variable: ", dat1)
	dat1 = null
	dat2 = null
	
	
	
#VARIABLES
func buscar_variable0(argumento):
	if nombre_comando == "Entonces":
		parametro0 = argumento
	else:
		if is_numeric(argumento):
			parametro0 = argumento.to_int()
		else:
			parametro0 = argumento
		if argumento in datos_numericos:
			parametro0 = datos_numericos[argumento]
		elif argumento in datos_caracter:
			parametro0 = datos_caracter[argumento]
		elif argumento in datos_logico:
			parametro0 = datos_logico[argumento]
		else:
			print("no existe la variable", argumento)
			if str(argumento).to_lower() == "true" or str(argumento).to_lower() == "false":
				parametro0 = str(argumento).to_lower() == "true"  # Convierte el argumento a un valor booleano
			elif is_numeric(argumento):
				parametro0 = argumento.to_int()
			else:
				parametro0 = argumento
	argumento = null
		
		
		
func buscar_variable1(argumento):
	if is_numeric(argumento):
		parametro1 = argumento.to_int()
	else:
		parametro1 = argumento
	if argumento in datos_numericos:
		parametro1 = datos_numericos[argumento]
	elif argumento in datos_caracter:
		parametro1 = datos_caracter[argumento]
	elif argumento in datos_logico:
		parametro1 = datos_logico[argumento] 
	elif argumento not in datos_operador:
		print("no existe la variable", argumento)
		if is_numeric(argumento):
			parametro1 = argumento.to_int()
		else:
			parametro1 = 0
	argumento = null
			
		
		
func buscar_variable2(argumento):
	if nombre_comando == "Entonces":
		parametro2 = argumento
	else:
		if is_numeric(argumento):
			parametro2 = argumento.to_int()
		else:
			parametro2 = argumento
		if argumento in datos_numericos:
			parametro2 = datos_numericos[argumento]
		elif argumento in datos_caracter:
			parametro2 = datos_caracter[argumento]
		elif argumento in datos_logico:
			parametro2 = datos_logico[argumento]
		else:
			print("no existe la variable", argumento)
			if str(argumento).to_lower() == "true" or str(argumento).to_lower() == "false":
				parametro2 = str(argumento).to_lower() == "true"  # Convierte el argumento a un valor booleano
			elif is_numeric(argumento):
				parametro2 = argumento.to_int()
			else:
				parametro2 = argumento
	argumento = null
	
	
	
#BUCLES
func bucle_para(vInicial, vFinal, sAcciones):
	print(vInicial, vFinal, sAcciones)
	for i in range(vInicial, vFinal):
		ejecutar_comando_sin_parametro(sAcciones)
		await get_tree().create_timer(0.8).timeout
	vInicial = null
	vFinal = null
	sAcciones = null
	
	
	
func bucle_mientras(_vInicial,_vFinal,_eLogica,_sAcciones):
	pass
	
	
	
func bucle_repetir(_sAcciones, _eLogica):
	pass
	
	
	
func esperaa(time):
	espera = time
	print(espera)
	time = null
	
	
	
#XDXDXD
func comunicar(mensaje):
	$Dialogo.visible = true
	$LabelDialogo.visible = true
	print("el dijo: ", mensaje)
	$LabelDialogo.text = mensaje
	await get_tree().create_timer(2.5).timeout
	$Dialogo.visible = false
	$LabelDialogo.visible = false
