extends Control
class_name menu

#variables de la conexion
var peer = ENetMultiplayerPeer.new()
var ip = "XDXDXDXD"
var conexion

#nodos de los botones
@onready var jugar = get_node("Jugar")
@onready var ip_del_server = get_node("As_ip")


func _ready():#funcion ready
	VIDA_MJ_GLOBAL.salud = 120
	VIDA_OP_GLOBAL.salud = 120
	VIDA_OP_GLOBAL.vivo = true
	ENERGIA_MJ_GLOBAL.energia = 120
	ENERGIA_OP_GLOBAL.energia = 120
	VIDA_MJ_GLOBAL.vivo = true
	
	
	
func _process(_delta):
	pass
	
	
	
func _on_as_ip_pressed():
	ip_del_server.disabled = true
	ip = $Ip.text
	var ip_address = ip 
	var resolved_ip = IP.resolve_hostname(ip_address)
	
	if resolved_ip == ip_address:
		print("La dirección IP es válida.")
		print(ip)
		conexion = peer.create_client(ip, 42424)
		jugar.disabled = false
	else:    
		print("La dirección IP no es válida.")
		ip_del_server.disabled = false
		
		
		
func conectado_al_server():
	get_tree().change_scene_to_file("res://Ecenas/jugadores.tscn")  
	
	
	
func desconectado_del_server():
	multiplayer.multiplayer_peer = null
	jugar.disabled = true
	get_tree().change_scene_to_file("res://Ecenas/menu.tscn")  
	
	
	
func _on_jugar_pressed():
	jugar.disabled = true
	print(ip)
	multiplayer.connected_to_server.connect(conectado_al_server)
	multiplayer.server_disconnected.connect(desconectado_del_server)

	if conexion != OK:  # Si hubo un error al crear el cliente.
		print("error " + str(conexion))  # Muestra el error si no se pudo conectar.
	else:
		multiplayer.multiplayer_peer = peer  # Establece el objeto de conexión de red para el servidor.
		
		
		
func _on_salir_pressed():
	get_tree().quit()
	
	
	
func _on_ip_text_changed(new_text):
	if new_text != "":
		ip_del_server.disabled = false
	else:
		ip_del_server.disabled = true
