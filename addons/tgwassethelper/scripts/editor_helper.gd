class_name TGWAssetHelperEditorScan
extends RefCounted

signal scan_ended

var prevent_duplicate_call = false
var _thread = Thread.new()
var _stop = false
var _sem = Semaphore.new()


func _init():
	_thread.start(_wait_scanning_end)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_stop = true
		_sem.post()
		_thread.wait_to_finish()


func start_scan():
	var editor_file_system: EditorFileSystem = EditorInterface.get_resource_filesystem()

	if !editor_file_system.is_scanning() || prevent_duplicate_call:
		prevent_duplicate_call = true
		Callable(
			func():
				editor_file_system.scan()
				_sem.post()
		).call_deferred()
	
		prevent_duplicate_call = false
	
	
func _wait_scanning_end():
	var editor_file_system: EditorFileSystem = EditorInterface.get_resource_filesystem()
	
	while true:
		if _stop:
			break
			
		_sem.wait()
			
		while editor_file_system.is_scanning():
			if _stop:
				break
				
			OS.delay_msec(20)
		
		scan_ended.emit()
		
