extends Sprite2D
class_name energiaoponente

var energia = 120
var visible_in_this_scene = false

@onready var textura120 = preload("res://SpritesF_C/ENERGIA/25.png")
@onready var textura115 = preload("res://SpritesF_C/ENERGIA/24.png")
@onready var textura110 = preload("res://SpritesF_C/ENERGIA/23.png")
@onready var textura105 = preload("res://SpritesF_C/ENERGIA/22.png")
@onready var textura100 = preload("res://SpritesF_C/ENERGIA/21.png")
@onready var textura95 = preload("res://SpritesF_C/ENERGIA/20.png")
@onready var textura90 = preload("res://SpritesF_C/ENERGIA/19.png")
@onready var textura85 = preload("res://SpritesF_C/ENERGIA/18.png")
@onready var textura80 = preload("res://SpritesF_C/ENERGIA/17.png")
@onready var textura75 = preload("res://SpritesF_C/ENERGIA/16.png")
@onready var textura70 = preload("res://SpritesF_C/ENERGIA/15.png")
@onready var textura65 = preload("res://SpritesF_C/ENERGIA/14.png")
@onready var textura60 = preload("res://SpritesF_C/ENERGIA/13.png")
@onready var textura55 = preload("res://SpritesF_C/ENERGIA/12.png")
@onready var textura50 = preload("res://SpritesF_C/ENERGIA/11.png")
@onready var textura45 = preload("res://SpritesF_C/ENERGIA/10.png")
@onready var textura40 = preload("res://SpritesF_C/ENERGIA/9.png")
@onready var textura35 = preload("res://SpritesF_C/ENERGIA/8.png")
@onready var textura30 = preload("res://SpritesF_C/ENERGIA/7.png")
@onready var textura25 = preload("res://SpritesF_C/ENERGIA/6.png")
@onready var textura20 = preload("res://SpritesF_C/ENERGIA/5.png")
@onready var textura15 = preload("res://SpritesF_C/ENERGIA/4.png")
@onready var textura10 = preload("res://SpritesF_C/ENERGIA/3.png")
@onready var textura5 = preload("res://SpritesF_C/ENERGIA/2.png")
@onready var textura0 = preload("res://SpritesF_C/ENERGIA/1.png")



func _ready():
	self.position = Vector2(300, 200)
	self.texture = textura120
	self.scale = Vector2(8, 8)
	
	
	
func _process(_delta):
	cambiar_textura(energia)
	self.visible = visible_in_this_scene
	
	
	
func perder_energia(energiaperdida):
	if energia <= 120:
		energia -= energiaperdida
	if energia <= 0:
		energia = 0
	
	
	
func recuperar_energia():
	while VIDA_MJ_GLOBAL.vivo and energia < 120:
		await get_tree().create_timer(5.0).timeout
		energia += 5
		print("se a aumentado 5 ahora es", energia)
		if energia > 120: # Si la energía supera los 120, la ajustamos a 120
			energia = 120
			print("se a ajustado la energia a", energia)
		if not VIDA_MJ_GLOBAL.vivo:
			energia = 0
			
			
			
func cambiar_textura(energy):
	if energy == 120:
		self.texture = textura120
	elif energy == 115:
		self.texture = textura115
	elif energy == 110:
		self.texture = textura110
	elif energy == 105:
		self.texture = textura105
	elif energy == 100:
		self.texture = textura100
	elif energy == 95:
		self.texture = textura95
	elif energy == 90:
		self.texture = textura90
	elif energy == 85:
		self.texture = textura85
	elif energy == 80:
		self.texture = textura80
	elif energy == 75:
		self.texture = textura75
	elif energy == 70:
		self.texture = textura70
	elif energy == 65:
		self.texture = textura65
	elif energy == 60:
		self.texture = textura60
	elif energy == 55:
		self.texture = textura55
	elif energy == 50:
		self.texture = textura50
	elif energy == 45:
		self.texture = textura45
	elif energy == 40:
		self.texture = textura40
	elif energy == 35:
		self.texture = textura35
	elif energy == 30:
		self.texture = textura30
	elif energy == 25:
		self.texture = textura25
	elif energy == 20:
		self.texture = textura20
	elif energy == 15:
		self.texture = textura15
	elif energy == 10:
		self.texture = textura10
	elif energy == 5:
		self.texture = textura5
	elif energy <= 0:
		self.texture = textura0
		
