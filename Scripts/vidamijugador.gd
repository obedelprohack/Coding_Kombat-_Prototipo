extends Sprite2D
class_name vidamijugador

var salud = 120 #salud igual a 120
var visible_in_this_scene = false
var vivo = true

@onready var textura120 = preload("res://SpritesF_C/VIDA/25.png")
@onready var textura115 = preload("res://SpritesF_C/VIDA/24.png")
@onready var textura110 = preload("res://SpritesF_C/VIDA/23.png")
@onready var textura105 = preload("res://SpritesF_C/VIDA/22.png")
@onready var textura100 = preload("res://SpritesF_C/VIDA/21.png")
@onready var textura95 = preload("res://SpritesF_C/VIDA/20.png")
@onready var textura90 = preload("res://SpritesF_C/VIDA/19.png")
@onready var textura85 = preload("res://SpritesF_C/VIDA/18.png")
@onready var textura80 = preload("res://SpritesF_C/VIDA/17.png")
@onready var textura75 = preload("res://SpritesF_C/VIDA/16.png")
@onready var textura70 = preload("res://SpritesF_C/VIDA/15.png")
@onready var textura65 = preload("res://SpritesF_C/VIDA/14.png")
@onready var textura60 = preload("res://SpritesF_C/VIDA/13.png")
@onready var textura55 = preload("res://SpritesF_C/VIDA/12.png")
@onready var textura50 = preload("res://SpritesF_C/VIDA/11.png")
@onready var textura45 = preload("res://SpritesF_C/VIDA/10.png")
@onready var textura40 = preload("res://SpritesF_C/VIDA/9.png")
@onready var textura35 = preload("res://SpritesF_C/VIDA/8.png")
@onready var textura30 = preload("res://SpritesF_C/VIDA/7.png")
@onready var textura25 = preload("res://SpritesF_C/VIDA/6.png")
@onready var textura20 = preload("res://SpritesF_C/VIDA/5.png")
@onready var textura15 = preload("res://SpritesF_C/VIDA/4.png")
@onready var textura10 = preload("res://SpritesF_C/VIDA/3.png")
@onready var textura5 = preload("res://SpritesF_C/VIDA/2.png")
@onready var textura0 = preload("res://SpritesF_C/VIDA/1.png")


		
func _ready():
	self.position = Vector2(1200, 100)
	self.texture = textura120
	self.scale = Vector2(8, 8)
	self.flip_h = true
	
	
	
func _process(_delta):
	cambiar_textura(salud)
	self.visible = visible_in_this_scene
	if salud <= 0:
		vivo = false
	
	
	
func perder_salud(dano):
	if salud <= 120:
		salud -= dano
		print("LA SALUD ES AHORA DE: ", salud)
	if salud <= 0:
		salud = 0
	
	
	
func recuperar_salud():
	while VIDA_MJ_GLOBAL.vivo and salud < 120:
		await get_tree().create_timer(5.0).timeout
		salud += 5
		print("se a aumentado 5 ahora es", salud)
		if salud > 120: # Si la energía supera los 120, la ajustamos a 120
			salud = 120
			print("se a ajustado la salud a", salud)
		if not VIDA_MJ_GLOBAL.vivo:
			salud = 0
			
		
		
func cambiar_textura(life):
	if life == 120:
		self.texture = textura120
	elif life == 115:
		self.texture = textura115
	elif life == 110:
		self.texture = textura110
	elif life == 105:
		self.texture = textura105
	elif life == 100:
		self.texture = textura100
	elif life == 95:
		self.texture = textura95
	elif life == 90:
		self.texture = textura90
	elif life == 85:
		self.texture = textura85
	elif life == 80:
		self.texture = textura80
	elif life == 75:
		self.texture = textura75
	elif life == 70:
		self.texture = textura70
	elif life == 65:
		self.texture = textura65
	elif life == 60:
		self.texture = textura60
	elif life == 55:
		self.texture = textura55
	elif life == 50:
		self.texture = textura50
	elif life == 45:
		self.texture = textura45
	elif life == 40:
		self.texture = textura40
	elif life == 35:
		self.texture = textura35
	elif life == 30:
		self.texture = textura30
	elif life == 25:
		self.texture = textura25
	elif life == 20:
		self.texture = textura20
	elif life == 15:
		self.texture = textura15
	elif life == 10:
		self.texture = textura10
	elif life == 5:
		self.texture = textura5
	elif life <= 0:
		self.texture = textura0
		
