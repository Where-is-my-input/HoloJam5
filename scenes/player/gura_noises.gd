extends AudioStreamPlayer2D

#It's a dictionary, meaning that the left side are the keys and the right side are the values
var DEATH = {
	"GURA___I_AM_GONNA_DIE_A_LOT_ON_THIS_GAME" = preload("res://assets/audio/Gura/Gura_-_I_am_gonna_die_a_lot_on_this_game.mp3"),
	"GURA___RANDOM_SOUND_11" = preload("res://assets/audio/Gura/Gura_-_random_sound_11.wav"),
	"GURA___RANDOM_SOUND_12" = preload("res://assets/audio/Gura/Gura_-_random_sound_12.mp3"),
	"GURA_BRUH" = preload("res://assets/audio/Gura/Gura_bruh.mp3"),
	"GURA_HAAAAAAAAW" = preload("res://assets/audio/Gura/Gura_haaaaaaaaw.mp3"),
	"IM_HAVING_FUN_ARE_YOU_HAVING_FUN" = preload("res://assets/audio/Gura/IM_HAVING_FUN_ARE_YOU_HAVING_FUN.mp3"),
	"NO" = preload("res://assets/audio/Gura/no.mp3"),
	"WHAT_IS_GURA_SUPPOSED_TO_DO" = preload("res://assets/audio/Gura/What_is_Gura_supposed_to_do.mp3")
}

var IDLE = {
	"astheysay" = preload("res://assets/audio/Gura/as_they_say.mp3"),
	"a" = preload("res://assets/audio/Gura/gura_-_a.mp3"),
	"GURA___WHAT" = preload("res://assets/audio/Gura/Gura_-_What.mp3")
}

var HIT = {
	"giggle" = preload("res://assets/audio/Gura/giggle154.mp3"),
	"bonk" = preload("res://assets/audio/Gura/GURA_-_BONK.mp3"),
	"GURA___STINKY" = preload("res://assets/audio/Gura/Gura_-_stinky.mp3"),
	"STINKY" = preload("res://assets/audio/Gura/stinky.mp3"),
	"SUCK_ON_DEEZ_NUTS" = preload("res://assets/audio/Gura/suck_on_deez_nuts.mp3")
}

var ACTION = {
	"GURA___WAH" = preload("res://assets/audio/Gura/Gura_-_Wah.mp3"),
	"GURA_ANIME_WOAH" = preload("res://assets/audio/Gura/Gura_Anime_Woah.mp3"),
	"GURA_EHEE" = preload("res://assets/audio/Gura/Gura_Ehee.mp3"),
	"GURA_POI_POI_POI_POI" = preload("res://assets/audio/Gura/Gura_poi_poi_poi_poi.wav"),
	"GURA_RANDOM_NOISE_1" = preload("res://assets/audio/Gura/Gura_random_noise_1.wav"),
	"HEEHEE" = preload("res://assets/audio/Gura/heehee.mp3")
}

var INSTALL_TRANSFORMATION = {
	"GURA_BATTLE_SCREECH" = preload("res://assets/audio/Gura/gura_battle_screech.wav"),
	"GURA_MANIACAL_LAUGH" = preload("res://assets/audio/Gura/Gura_Maniacal_Laugh.wav")
}

var WIN = {
	"GURA_EASY" = preload("res://assets/audio/Gura/Gura_easy.mp3")
}

# player -> where the soundPlayer is, clip_key the song that will actually play
#func PlayClip(player, clip_key: String):
	##check if the key exist, if not just return
	#if SOUNDS.has(clip_key) == false:
		#return
	## if it do exist, then we change it to the correctly SoundPlayer and play it 
	#player.stream = SOUNDS[clip_key]
	##player.set_loop_mode(1)
	#player.play()
func playAction():
	playClip(ACTION)

func playIdle():
	playClip(IDLE)

func playDeath():
	playClip(DEATH)

func playHit():
	playClip(HIT)

func playClip(array):
	var key = array.keys()[randi_range(0, array.size() - 1)]
	stream = array[key]
	play()
