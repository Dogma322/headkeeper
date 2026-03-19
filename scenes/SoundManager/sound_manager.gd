extends Node2D

var active_player
var inactive_player


@onready var mus_a = $AudioStreamPlayer1
@onready var mus_b = $AudioStreamPlayer2
@onready var sounds = $Sounds

@onready var domino_sound = preload("res://assets/Sound/Sounds/Domino/DominoPlay1.wav")
@onready var discard_all_dominoes_sound = preload("res://assets/Sound/Sounds/Domino/DominoesDiscard.wav")

@onready var block_sound = preload("res://assets/Sound/Sounds/Fight/ArmorAdd.wav")
@onready var damage_sound = preload("res://assets/Sound/Sounds/Fight/ArmorDamageSoundwav.wav")
@onready var buff_sound = preload("res://assets/Sound/Sounds/Fight/Buff.wav")
@onready var heal_sound = preload("res://assets/Sound/Sounds/Fight/Heal.wav")
@onready var status_sound = preload("res://assets/Sound/Sounds/Fight/StatusSound2.wav")

@onready var action_card_sound = preload("res://assets/Sound/Sounds/ActionCard/CardSound.wav")




# Called when the node enters the scene tree for the first time.
func _ready():
	active_player = mus_a
	inactive_player = mus_b
	active_player.volume_db = -25
	inactive_player.volume_db = -30  # тихо, но слышно
	
	Signals.play_domino_added_to_slot_sound.connect(play_domino_added_to_slot_sound)
	Signals.play_domino_draged_sound.connect(play_domino_draged_sound)
	Signals.play_domino_play_sound.connect(play_domino_play_sound)
	Signals.play_discard_all_dominoes_sound.connect(play_discard_all_dominoes_sound)
	
	Signals.play_action_card_sound.connect(play_action_card_sound)
	
	Signals.play_block_sound.connect(play_block_sound)
	Signals.play_damage_sound.connect(play_damage_sound)
	Signals.play_status_sound.connect(play_status_sound)
	Signals.play_heal_sound.connect(play_heal_sound)
	

func set_music(theme,fade_time := 3):
	
	if CombatManager.stage == 10:
		theme = "Boss"
	
	
	var stream
	var final_volume
	
	if theme == "MainMenu":
		final_volume = -20
		stream = load("res://assets/Sound/Music/Eternal_sleep.ogg")
	
	if theme == "MushroomCaves":
		final_volume = -5
		stream = load("res://assets/Sound/Music/MystOnTheMoor.ogg")
		
	if theme == "CursedSwamp":
		final_volume = -20
		stream = load("res://assets/Sound/Music/MainMusic1.ogg")
		
	if theme == "MutatingForest":
		final_volume = -10
		stream = load("res://assets/Sound/Music/UnseenMonarch.ogg")
		
	if theme == "Boss":
		final_volume = -8
		stream = load("res://assets/Sound/Music/I_Will_Find_You.ogg")

	if active_player.stream == stream:
		return

	inactive_player.stream = stream
	inactive_player.play()

	inactive_player.volume_db = -30  # стартуем с тихого, но слышимого уровня

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(active_player, "volume_db", -60, fade_time) # старая музыка затухает
	tween.tween_property(inactive_player, "volume_db", final_volume, fade_time) # новая входит

	var temp = active_player
	active_player = inactive_player
	inactive_player = temp

func play_domino_added_to_slot_sound():
	play_sound(domino_sound, -10)
	
func play_domino_draged_sound():
	play_sound(domino_sound, -30)
	
func play_domino_play_sound():
	play_sound(domino_sound, -15)
	
func play_discard_all_dominoes_sound():
	play_sound(discard_all_dominoes_sound, -15)



func play_action_card_sound():
	play_sound(action_card_sound, -15)



func play_block_sound():
	play_sound(block_sound, -12)
	
func play_buff_sound():
	play_sound(buff_sound, -10)
	
func play_heal_sound():
	play_sound(heal_sound, -15)

func play_damage_sound():
	play_sound(damage_sound, -15)
	
func play_status_sound():
	play_sound(status_sound, -15)




func play_sound(sound: AudioStream, volume_amount):
	var p = AudioStreamPlayer.new()
	p.stream = sound
	p.volume_db += volume_amount
	p.bus = "SFX"
	sounds.add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
