#class_name SoundManager 
extends Node
enum BGM {GMAE_MENU, IN_GAME, ED}
var _BMG_list = {
	BGM.GMAE_MENU : preload("res://audio/game_menu.mp3"),
	BGM.IN_GAME : preload("res://audio/in_game.mp3"),
	BGM.ED : preload("res://audio/主題曲試作-Eyes of the Dragon/Eyes_of_the_Dragon.ogg")
}
enum EFFECT {ROAR, SUCCES, BLOCK, CLICK}
var _effect_list = {
	EFFECT.ROAR:preload("res://audio/dragon_roar.wav"), # 龍低吼聲
	EFFECT.SUCCES:preload("res://audio/success.ogg")
}
var block_list := [ # block
	preload("res://audio/block/impactPunch_heavy_000.ogg"),
	preload("res://audio/block/impactPunch_heavy_001.ogg"),
	preload("res://audio/block/impactPunch_heavy_002.ogg"),
	preload("res://audio/block/impactPunch_heavy_003.ogg"),
	preload("res://audio/block/impactPunch_heavy_004.ogg"),
]
var button_click := [ # click
	preload("res://audio/button_click/click1.ogg"),
	preload("res://audio/button_click/click2.ogg"),
	preload("res://audio/button_click/click3.ogg"),
	preload("res://audio/button_click/click4.ogg"),
	preload("res://audio/button_click/click5.ogg")
]
func _ready():
	_BGM_player = AudioStreamPlayer.new()
	_BGM_player.finished.connect(_BGM_player.play)
	add_child(_BGM_player)
	_effect_player = AudioStreamPlayer.new()
	_effect_player.bus = "EffectBus"
	add_child(_effect_player)

var _BGM_player:AudioStreamPlayer
func play_BGM(str:BGM):
	_BGM_player.stream = _BMG_list[str]
	_BGM_player.play()


var _effect_player:AudioStreamPlayer
func play_effect(str:EFFECT):
	match str:
		EFFECT.BLOCK:
			_effect_player.stream = block_list.pick_random()
		EFFECT.CLICK:
			_effect_player.stream = button_click.pick_random()
		_:
			_effect_player.stream = _effect_list[str]
	_effect_player.play()


func play_ohno():
	var ohno := AudioStreamPlayer.new()
	var node = preload("res://script/ohno_scene/Ohno.tscn").instantiate()
	add_child(node)
	add_child(ohno)
	ohno.bus = "OhnoBus"
	ohno.stream = _BMG_list[BGM.GMAE_MENU]
	ohno.play()
	get_tree().create_timer(5.0).timeout.connect(ohno.queue_free)
	get_tree().create_timer(5.0).timeout.connect(node.queue_free)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		play_effect(EFFECT.CLICK)




#
