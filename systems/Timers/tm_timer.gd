extends Object
class_name TMTimer

var id : int
var active : bool
var target : int
var timeFunc : Callable
var waitTime : float
var timeMod : int
var looping : bool
var oneshot : bool
var callback : Callable

static func create(t_id : int, t_waitTime : float, t_looping : bool, t_oneshot : bool, t_precision : TimerManager.PRECISION, t_callback : Callable) -> TMTimer:
	var newTimer : TMTimer = TMTimer.new()
	newTimer.id = t_id
	newTimer.active = false
	newTimer.waitTime = t_waitTime
	newTimer.looping = t_looping
	newTimer.oneshot = t_oneshot
	if t_looping && t_oneshot :
		push_warning(
		"Creating a looping oneshot timer makes no sense.\n" +
		"The preference is set to looping timers, oneshot property will be ignored.\n" + 
		"Please set your timer's values properly. ID: " + str(t_id)
		)
	newTimer.callback = t_callback
	newTimer.target = 0
	match t_precision:
		TimerManager.PRECISION.MICROSECOND:
			newTimer.timeFunc = Time.get_ticks_usec
			newTimer.timeMod = 1000
		TimerManager.PRECISION.MILLISECOND:
			newTimer.timeFunc = Time.get_ticks_msec
			newTimer.timeMod = 1
		_:
			newTimer.timeFunc = Time.get_ticks_msec
			newTimer.timeMod = 1
	return newTimer

func start() -> void:
	target = timeFunc.call() + waitTime * timeMod
	active = true

func rem() -> int :
	return target - timeFunc.call()

func finished() -> bool :
	return !active || timeFunc.call() > target
