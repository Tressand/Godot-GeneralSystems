@icon("res://Timers/Timers.svg")
extends Node
class_name TimerManager

enum PRECISION {
	MILLISECOND,
	MICROSECOND
}

static var time_suffixes : Dictionary[int,String] = {
	-2:"μs",
	-1:"ms",
	0:"s",
	1:"min",
	2:"hr",
	3:"day",
	4:"mon",
	5:"yr"
}

var timers : Array[TMTimer] = []
var idCounter : int = 0

func _process(_delta: float) -> void:
	for timer : TMTimer in timers :
		if !timer.active: continue
		if timer.timeFunc.call() >= timer.target:
			timer.callback.call()
			if timer.looping: timer.start()
			elif timer.oneshot: remove_t_by_id(timer.id)
			else: timer.active = false

func find(id : int) -> int:
	var i : int = 0
	while i < len(timers):
		if timers[i].id == id: return i
		i += 1
	return -1

func add_t(waitTime_ms : int, callback : Callable, autostart : bool, looping : bool = false, oneshot : bool = false, precision : PRECISION = PRECISION.MILLISECOND) -> TMTimer:
	idCounter += 1
	var timer : TMTimer = TMTimer.create(idCounter, waitTime_ms, looping, oneshot , precision, callback)
	timers.append(timer)
	if autostart : timer.start()
	return timer

func get_t(id : int) -> TMTimer:
	var index : int = find(id)
	return timers[index] if index != -1 else null

func remove_t_by_id(id : int) -> void:
	var index : int = find(id)
	if index == -1 : return
	var timer : TMTimer = timers[index]
	timers.remove_at(index)
	timer.queue_free()

func clear() -> void:
	timers.clear()
