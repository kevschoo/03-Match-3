extends Node2D

# Board Variables
export (int) var width 
export (int) var height 
export (int) var xStart 
export (int) var yStart 
export (int) var offset

# Timers
var piece = null
var new_position = Vector2(0,0)

# Piece Stuff
var possible_pieces = [
]

var all_pieces

var first_touch
var final_touch
var controlling = false

export (PackedScene) var background

func _ready():
	randomize()
	all_pieces = make_array()
	setup_board()
	generate_pieces()

func make_array():
	var matrix = [ ]
	for x in range(width):
		matrix.append([ ])
		for _y in range(height):
			matrix[x].append(0)
	return matrix

func setup_board():
	for i in width:
		for j in height:
			var b = background.instance()
			add_child(b)
			b.position = Vector2((xStart + (i * offset)), (yStart - (j * offset)))

func generate_pieces():
	for i in width:
		for j in height:
			var piece_to_use = round(rand_range(0, possible_pieces.size()))
			if piece_to_use == 6:
				piece_to_use = 5
			var piece = possible_pieces[piece_to_use].instance()
			
			var loops = 0
			while check_for_matches(i,j, piece.color) && loops < 100:
				piece_to_use = round(rand_range(0, possible_pieces.size()))
				if piece_to_use == 6:
					piece_to_use = 5
				piece = possible_pieces[piece_to_use].instance()
				loops += 1
			
			add_child(piece)
			piece.position = Vector2(xStart + i * offset, yStart - j * offset)
			all_pieces[i][j] = piece

func check_for_matches(column, row, color):
	#Check Left
	if column > 1 && row <= 1:
		if(all_pieces[column - 1][row].color == color):
			if(all_pieces[column - 2][row].color == color):
				return true
	#Check right
	elif column <= 1 && row > 1:
		if(all_pieces[column][row - 1].color == color):
			if(all_pieces[column][row - 2].color == color):
				return true
	#Check Both
	elif column > 1 && row > 1:
		if((all_pieces[column - 1][row].color == color
		&& all_pieces[column - 2][row].color == color)
		|| (all_pieces[column][row -1].color == color
		&& (all_pieces[column][row - 2].color == color))):
			return true
	return false

func pixel_to_grid(touch_position):
	var column = round((touch_position.x - xStart)/offset)
	var row = round((touch_position.y - yStart)/-offset)
	return Vector2(column, row)

func is_in_grid(touch_position):
	if(touch_position.x >= 0 && touch_position.x < width):
		if(touch_position.y >= 0 && touch_position.y < height):
			return true
	return false

func swap_pieces(column, row, direction):
	var first_piece = all_pieces[column][row]
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	all_pieces[column + direction.x][row + direction.y] = first_piece
	all_pieces[column][row] = other_piece
	first_piece.move_piece(Vector2(direction.x * offset, direction.y * -offset))
	other_piece.move_piece(Vector2(direction.x * -offset, direction.y * offset))

func touch_difference(first_touch, final_touch):
	var difference = final_touch - first_touch
	if(abs(difference.x) > abs(difference.y)):
		if(difference.x > 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(1, 0))
		elif(difference.x < 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(-1, 0))
	elif(abs(difference.y) > abs(difference.x)):
		if(difference.y > 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(0, 1))
		elif(difference.y < 0):
			swap_pieces(first_touch.x, first_touch.y, Vector2(0, -1))

func _process(_delta):
	touch_input()
	find_matches()
	refill_columns()
	

func find_matches():
	for i in width:
		for j in height:
			#Check left and right
			if i > 0 && i < width - 1:
				var color = all_pieces[i][j].color
				if (all_pieces[i - 1][j].color == color 
				&& all_pieces[i + 1][j].color == color):
					all_pieces[i - 1][j].is_matched = true
					all_pieces[i + 1][j].is_matched = true
					all_pieces[i][j].is_matched = true
			if j > 0 && j < height - 1:
				var color = all_pieces[i][j].color
				if (all_pieces[i][j - 1].color == color 
				&& all_pieces[i][j + 1].color == color):
					all_pieces[i][j - 1].is_matched = true
					all_pieces[i][j + 1].is_matched = true
					all_pieces[i][j].is_matched = true
	destroy_matched()

func destroy_matched():
	for i in width:
		for j in height:
			if(all_pieces[i][j].is_matched):
				all_pieces[i][j].queue_free()
				all_pieces[i][j] = null
	collapse_columns()

func collapse_columns():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null):
				for k in range(j + 1, height):
					if(all_pieces[i][k] != null):
						all_pieces[i][j] = all_pieces[i][k]
						#all_pieces[i][k].position = Vector2(i * offset + xStart, -j * offset + yStart)
						all_pieces[i][k].move_piece(Vector2(0, (k-j) * offset))
						all_pieces[i][k] = null
						break

func refill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				var piece_to_use = round(rand_range(0, possible_pieces.size()))
				if piece_to_use == 6:
					piece_to_use = 5
				piece = possible_pieces[piece_to_use].instance()
				
				var loops = 0
				while check_for_matches(i,j, piece.color) && loops < 100:
					piece_to_use = round(rand_range(0, possible_pieces.size()))
					if piece_to_use == 6:
						piece_to_use = 5
					piece = possible_pieces[piece_to_use].instance()
					loops += 1
				
				add_child(piece)
				piece.position = Vector2(xStart + i * offset, yStart - j * offset)
				all_pieces[i][j] = piece

func touch_input():
	if(Input.is_action_just_pressed("ui_touch")):
		if(is_in_grid(pixel_to_grid(get_global_mouse_position()))):
			controlling = true
			first_touch = pixel_to_grid(get_global_mouse_position())
	if(Input.is_action_just_released("ui_touch") && controlling):
		if(is_in_grid(pixel_to_grid(get_global_mouse_position()))):
			controlling = false
			final_touch = pixel_to_grid(get_global_mouse_position())
			touch_difference(first_touch, final_touch)

func move_piece(piece, position_change):
	piece.position += position_change

