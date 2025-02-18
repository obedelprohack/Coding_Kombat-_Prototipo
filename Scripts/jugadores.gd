extends menu
class_name jugadores

var local_peer = 0  # ID del cliente local. Se inicializa en 0.
var lista_de_jugadores = {}
var lista_de_clientes = {}  # Esta línea inicializa un diccionario vacío para almacenar la lista de clientes.
var lista_de_users = {}  # Esta línea inicializa un diccionario vacío para almacenar la lista de usuarios.
var lista_de_ids = {}  # Esta línea inicializa un diccionario vacío para almacenar la lista de IDs.



func _ready():
	multiplayer.server_disconnected.connect(desconectado)
	multiplayer.peer_connected.connect(cuando_otro_jugador_se_conecta)
	multiplayer.peer_disconnected.connect(cuando_otro_jugador_se_desconecta)
	GLOBAL.username = "Player_" + str(get_tree().get_multiplayer().get_unique_id())
	$Name.text = GLOBAL.username
	
	
	
func _process(_delta):
	pass
	
	
	
func desconectado():
	multiplayer.multiplayer_peer = null
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Ecenas/menu.tscn")
	
	
	
func _on_menu_pressed():
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://Ecenas/menu.tscn")
	
	
	
func cuando_otro_jugador_se_conecta(peer_id):
	var username = "player_" +str(peer_id)  # Esta línea establece el nombre de usuario en "ds".
	agregar_ala_lista(username)  # Esta línea llama a la función "agregar_ala_lista" con el nombre de usuario como argumento.
	lista_de_ids[username] = peer_id  # Esta línea agrega el ID del par a la lista de IDs con el nombre de usuario como clave.
	
	
	
func agregar_ala_lista(peer_id):  # Esta función agrega un cliente a la lista de clientes.
	if local_peer == 0:  # Si el ID del cliente local es 0.
		local_peer = peer.get_unique_id()  # Obtiene el ID único del cliente local.
		
		var item_index = $PlayerList.add_item(str(peer_id) + "      conectado")  # Agrega el cliente a la lista de clientes
		lista_de_clientes[peer_id] = item_index  # Guarda el índice del elemento de la lista
		
		
		
func obtener_clave_por_valor(diccionario, valor):  # Esta función obtiene la clave para un valor dado en un diccionario.
	for clave in diccionario.keys():  # Esta línea itera sobre las claves en el diccionario.
		if diccionario[clave] == valor:  # Esta línea verifica si el valor para la clave actual es igual al valor dado.
			return clave  # Esta línea devuelve la clave si el valor para la clave actual es igual al valor dado.
	return null  # Esta línea devuelve null si no se encontró ninguna clave para el valor dado.
	
	
	
func cuando_otro_jugador_se_desconecta(peer_id):
	if (local_peer == peer_id || peer_id == 1): # Si el cliente local se desconecta o si el servidor se cierra.
		local_peer = 0  # Reinicia el ID del cliente local a 0.
		
	var username = obtener_clave_por_valor(lista_de_ids, peer_id)  # Esta línea obtiene el nombre de usuario para el ID del par dado.
	if username != null:  # Esta línea verifica si se encontró un nombre de usuario para el ID del par dado.
		var clientee = lista_de_clientes[username]  # Esta línea obtiene el cliente para el nombre de usuario dado.
		$PlayerList.remove_item(clientee)  # Esta línea elimina el cliente de la lista de clientes.
		lista_de_ids.erase(username)  # Esta línea elimina el nombre de usuario de la lista de IDs.
		# Actualiza los índices en lista_de_clientes
		
		for id in lista_de_clientes.keys():  # Esta línea itera sobre las claves en la lista de clientes.
			if lista_de_clientes[id] > clientee:  # Esta línea verifica si el cliente actual es mayor que el cliente eliminado.
				lista_de_clientes[id] -= 1  # Esta línea decrementa el índice del cliente actual si es mayor que el cliente eliminado.
				
				
				
func _on_player_list_item_selected(index):
	GLOBAL.id_oponente = $PlayerList.get_item_text(index).split(" ")[0].to_int()
	$Play.disabled = false
	
	
	
func _on_play_pressed():
	print(GLOBAL.id_oponente)
	get_tree().change_scene_to_file("res://Ecenas/arena.tscn")
