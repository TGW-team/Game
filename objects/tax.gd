class_name Tax
extends Node


var tax_value: float = 0.0

var min_value: float = 0.0
var max_value: float = 0.3


func reduce_tax(num: float):
	if tax_value - num < min_value:
		tax_value = min_value
	else:
		tax_value -= num


func increase_tax(num: float):
	if tax_value + num > max_value:
		tax_value = max_value
	else:
		tax_value += num
