extends Node

var Animal_puzzle_1 = false
var Animal_puzzle_2 = false
var Animal_puzzle_3 = false
var Flower_Puzzle_1 = false
var Flower_Puzzle_2 = false
var Landscape_Puzzle_1 = false
var Landscape_Puzzle_2 = false
var History_puzzle_1 = false
var History_puzzle_2 = false

func mark_puzzle_complete(puzzle_id: String):
	match puzzle_id:
		"animal_1": Animal_puzzle_1 = true
		"animal_2": Animal_puzzle_2 = true
		"animal_3": Animal_puzzle_3 = true
		"flower_1": Flower_Puzzle_1 = true
		"flower_2": Flower_Puzzle_2 = true
		"landscape_1": Landscape_Puzzle_1 = true
		"landscape_2": Landscape_Puzzle_2 = true
		"history_1": History_puzzle_1 = true
		"history_2": History_puzzle_2 = true

func all_animal_puzzles_done() -> bool:
	return Animal_puzzle_1 and Animal_puzzle_2 and Animal_puzzle_3

func all_flower_puzzles_done() -> bool:
	return Flower_Puzzle_1 and Flower_Puzzle_2

func all_landscape_puzzles_done() -> bool:
	return Landscape_Puzzle_1 and Landscape_Puzzle_2

func all_history_puzzles_done() -> bool:
	return History_puzzle_1 and History_puzzle_2

func all_puzzles_done() -> bool:
	return all_animal_puzzles_done() and all_flower_puzzles_done() and all_landscape_puzzles_done()
