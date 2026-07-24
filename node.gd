extends Node

var questions = []
var current_index = 0
var score = 0
var total = 0

func _ready():
	load_questions()

func load_questions():
	var file = FileAccess.open("res://questions.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data:
			questions = data
			total = questions.size()
			show_home()
		else:
			show_error("JSON ফরম্যাট ঠিক নেই")
	else:
		show_error("questions.json ফাইল পাওয়া যায়নি")

func clear_ui():
	for child in get_children():
		child.queue_free()

func show_error(msg):
	clear_ui()
	var label = Label.new()
	label.text = "Error: " + msg
	add_child(label)

func show_home():
	clear_ui()
	var title = Label.new()
	title.text = "ODE MCQ (সাধারণ ব্যবকলনীয় সমীকরণ)"
	title.position = Vector2(100, 100)
	add_child(title)

	var btn = Button.new()
	btn.text = "কুইজ শুরু করুন"
	btn.position = Vector2(100, 200)
	btn.pressed.connect(_on_start_pressed)
	add_child(btn)

func _on_start_pressed():
	current_index = 0
	score = 0
	show_question()

func show_question():
	clear_ui()
	if current_index >= total:
		show_result()
		return

	var q = questions[current_index]
	
	var q_label = Label.new()
	q_label.text = str(current_index+1) + ". " + q.question
	q_label.position = Vector2(50, 50)
	q_label.size = Vector2(300, 80)
	q_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	add_child(q_label)

	var y = 150
	for i in range(q.options.size()):
		var btn = Button.new()
		btn.text = q.options[i]
		btn.position = Vector2(50, y + i*60)
		btn.size = Vector2(300, 50)
		btn.pressed.connect(_on_option_pressed.bind(i))
		add_child(btn)

	var score_label = Label.new()
	score_label.text = "স্কোর: " + str(score) + "/" + str(total)
	score_label.position = Vector2(50, 400)
	add_child(score_label)

func _on_option_pressed(index):
	var q = questions[current_index]
	if index == q.correct_answer:
		score += 1
	current_index += 1
	show_question()

func show_result():
	clear_ui()
	var label = Label.new()
	label.text = "🎉 কুইজ শেষ!\nআপনার স্কোর: " + str(score) + "/" + str(total)
	label.position = Vector2(100, 200)
	add_child(label)

	var btn = Button.new()
	btn.text = "আবার খেলুন"
	btn.position = Vector2(150, 300)
	btn.pressed.connect(_on_start_pressed)
	add_child(btn)
