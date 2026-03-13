extends Node

# Цвет обычных ключевых слов
const KEYWORD_COLOR := "#FFAA00"

# Подсветка 4 специальных слов: слово → цвет
const SPECIAL_COLORS := {
	"ru": {
		"Атаки": "#FF5555",   # красный
		"Защиты": "#5599FF",  # синий
		"Навыков": "#55FF55",   # зелёный
		"Талантов": "#AA55FF"   # фиолетовый
	},
	"en": {
		"Attack": "#FF5555",
		"Defense": "#5599FF",
		"Skill": "#55FF55",
		"Power": "#AA55FF"
	}
}

# Прочие ключевые слова (подсвечиваются оранжевым)
const KEYWORDS := {
	"ru": ["Ярость", "Ярости", "Слабость", "Слабости", "Шипы", "Шипов", "Скверна", "Скверны", "Уязвимость", "Уязвимости"],
	"en": ["Fury", "Weak", "Thorns", "Corruption", "Vulnerable" ]
}


# Главная функция — универсальный форматтер описания
func format_description(raw_text: String, value: int = -1, base: int = -1) -> String:
	var text := raw_text

	# Подставим цветное число, если есть %s
	if raw_text.contains("%s") and value >= 0 and base >= 0:
		text = raw_text % [highlight_number(value, base)]

	# Подсветим ключевые слова
	text = highlight_keywords(text)

	# Центрируем текст
	return "[center]%s[/center]" % text


# Подсвечивает число (зелёное, красное или обычное)
func highlight_number(value: int, base: int) -> String:
	if value > base:
		return "[color=green]%s[/color]" % str(value)
	elif value < base:
		return "[color=red]%s[/color]" % str(value)
	else:
		return str(value)


# Подсвечивает ключевые слова по словарям
func highlight_keywords(text: String) -> String:
	var locale: String = TranslationServer.get_locale()

	# Получаем специальные и обычные слова
	var specials: Dictionary = SPECIAL_COLORS.get(locale, {})
	var commons = KEYWORDS.get(locale, [])

	# Сначала подсветим специальные слова (Атака, Навык и т.д.)
	for word in specials.keys():
		var color = specials[word]
		text = text.replace(word, "[color=%s]%s[/color]" % [color, word])

	# Потом обычные слова — если они ещё не закрашены
	for word in commons:
		if not text.find("[color=", text.find(word) - 10) > -1:
			text = text.replace(word, "[color=%s]%s[/color]" % [KEYWORD_COLOR, word])

	return text
	
	
func insert_colored_value(text: String, value: int, base: int) -> String:
	var colored_value := ""
	if value > base:
		colored_value = "[color=green]%s[/color]" % str(value)
	elif value < base:
		colored_value = "[color=red]%s[/color]" % str(value)
	else:
		colored_value = str(value)

	# Подставим это значение в %s
	text = text % [colored_value]
	#return text
	return highlight_keywords(text)
