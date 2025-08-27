extends Object

class_name GLog

static func typeof_str(v : Variant) -> String : 
	return v.get_class() if typeof(v) == TYPE_OBJECT else type_string(typeof(v))

static func str_conv(value: Variant) -> String:
	match typeof_str(value):
		_:
			return str(value)

static func log(values : Array) -> void:
	var msg : String = ""
	for value : Variant in values:
		msg += str_conv(value) + " "
	print_rich(msg.left(-1))
