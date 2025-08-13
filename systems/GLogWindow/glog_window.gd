extends Node
class_name GLogWindow

@export var default_visible : bool
@export var show_window_hotkey : Key
@export var freeze_hotkey : Key
var log_active : bool = true
var hotkey_click : bool = false
@export var window : Window
@export var container : Control
@export var templates : Node

func instantiate_template(v_type : String) -> VariableVisual:
	var selected_template : VariableVisual = templates.get_child(0)
	for template : VariableVisual in templates.get_children():
		if template.name == v_type :
			selected_template = template
			break
	var instance : VariableVisual = selected_template.self_duplicate()
	container.add_child(instance)
	instance.owner = self
	instance.visible = true
	return instance

class LogVariable :
	var tag : String
	var variable : Variant
	var visual : VariableVisual
	
	func update_visual() -> void:
		self.visual._set_value(self.tag, self.variable)
	
	static func create(n_tag : String, n_variable : Variant, n_visual : VariableVisual) -> LogVariable:
		var newVariable : LogVariable = LogVariable.new()
		newVariable.tag = n_tag
		newVariable.variable = n_variable
		newVariable.visual = n_visual
		return newVariable

var log_variables : Array[LogVariable]

func add_variable(tag: String, value: Variant) -> void:
	var type : int = typeof(value)
	@warning_ignore("unsafe_cast")
	log_variables.append(LogVariable.create(
		tag,
		value,
		instantiate_template((value as Object).get_class() if type == TYPE_OBJECT else type_string(type))
	))

func update_variable(tag : String, value: Variant, add_if_missing : bool = false) -> void:
	for variable : LogVariable in log_variables :
		if variable.tag == tag:
			variable.variable = value
			return
	if add_if_missing : add_variable(tag, value)

func _ready() -> void:
	window.visible = default_visible
	window.close_requested.connect(func()->void: window.visible = false)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(show_window_hotkey) :
		if !hotkey_click :
			hotkey_click = true
			window.visible = !window.visible
	elif Input.is_key_pressed(freeze_hotkey):
		if !hotkey_click :
			hotkey_click = true
			log_active = !log_active
	else:
		hotkey_click = false

func _process(_delta: float) -> void:
	if !log_active : return
	for variable : LogVariable in log_variables:
			variable.update_visual()
