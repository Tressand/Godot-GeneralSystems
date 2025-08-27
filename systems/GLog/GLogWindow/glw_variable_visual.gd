extends Control
class_name VariableVisual

@warning_ignore("unused_parameter")
func _set_value(tag: String, value: Variant) -> void:
	pass

func self_duplicate() -> VariableVisual:
	return self.duplicate()
