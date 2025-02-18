extends Control
class_name gameover


func _ready():
	VIDA_MJ_GLOBAL.visible_in_this_scene = false
	VIDA_OP_GLOBAL.visible_in_this_scene = false
	ENERGIA_MJ_GLOBAL.visible_in_this_scene = false
	ENERGIA_OP_GLOBAL.visible_in_this_scene = false
	ganador()
	$Label3.text = GLOBAL.tiempo
	
	
	
func _process(_delta):
	pass
	
	
	
func ganador():
	await get_tree().create_timer(0.5).timeout  # Espera por la duración de los pasos
	if VIDA_OP_GLOBAL.salud <= 0:
		$Label2.set_text("WINNER")
	elif VIDA_MJ_GLOBAL.salud <= 0:
		$Label2.set_text("WINNER:Player_" + str(GLOBAL.id_oponente))
		
		
		
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Ecenas/menu.tscn")
	
	
	
func _on_button_2_pressed(): 
	get_tree().quit()
