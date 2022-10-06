module vglfw

import duarteroso.semver

// Forward declaration
fn C.glfwInit() int

fn C.glfwTerminate()

fn C.glfwInitHint(hint int, value int)

fn C.glfwGetVersion(major &int, minor &int, rev &int)

fn C.glfwGetVersionString() &char

fn C.glfwGetError(description &&char) int

fn C.glfwSetErrorCallback(callback FnError) FnError

fn C.glfwGetMonitors(count &int) &voidptr

fn C.glfwGetPrimaryMonitor() &C.GLFWmonitor

fn C.glfwSetMonitorCallback(callback FnMonitor) FnMonitor

fn C.glfwDefaultWindowHints()

fn C.glfwWindowHint(hint int, value int)

fn C.glfwWindowHintString(hint int, value &char)

fn C.glfwPollEvents()

fn C.glfwWaitEvents()

fn C.glfwWaitEventsTimeout(timeout f64)

fn C.glfwPostEmptyEvent()

fn C.glfwRawMouseMotionSupported() int

fn C.glfwGetKeyName(key int, scan_code int) &char

fn C.glfwGetKeyScancode(key int) int

fn C.glfwGetTime() f64

fn C.glfwSetTime(time f64)

fn C.glfwGetTimerValue() u64

fn C.glfwGetTimerFrequency() u64

fn C.glfwSwapInterval(interval int)

fn C.glfwExtensionSupported(extension &char) int

fn C.glfwGetProcAddress(procname &char) FnGLProc

fn C.glfwVulkanSupported() int

fn C.glfwGetRequiredInstanceExtensions(count &u32) &&char

fn C.glfwSetJoystickCallback(callback FnJoystick) FnJoystick

fn C.glfwUpdateGamepadMappings(mappings &char) int

// initialize GLFW
pub fn initialize() bool {
	ok := C.glfwInit()
	check_error()
	return ok == glfw_true
}

// terminate GLFW
pub fn terminate() {
	C.glfwTerminate()
	check_error()
}

// init_hint writes hint for the initialization process
pub fn init_hint(hint int, value int) {
	C.glfwInitHint(hint, value)
	check_error()
}

// get_version gets the current GLFW version
pub fn get_version(major &int, minor &int, rev &int) {
	C.glfwGetVersion(major, minor, rev)
}

// get_semantic_version gets the current GLFW semantic version
pub fn get_semantic_version() semver.SemVer {
	v := semver.SemVer{}
	get_version(v.major, v.minor, v.patch)
	return v
}

// get_version_string gets the current GLFW version as string
pub fn get_version_string() string {
	s := C.glfwGetVersionString()
	return unsafe { s.vstring() }
}

// get_error gets the current unhandled GLFW error.
// Should be call after each GLFW method that can
// produce an error.
pub fn get_error() Err {
	mut m := &char(0)
	c := C.glfwGetError(&m)
	//
	return Err{
		code: c
		msg: if c == glfw_no_error { '' } else { unsafe { m.vstring() } }
	}
}

// check_error will panic if there is an error
pub fn check_error() {
	err := get_error()
	if err.code != glfw_no_error {
		panic(err.str())
	}
}

// set_error_callback sets error callback
pub fn set_error_callback(cb FnError) FnError {
	return C.glfwSetErrorCallback(cb)
}

// get_monitors retrieves all available monitors
pub fn get_monitors() []&Monitor {
	count := 0
	c_monitors := C.glfwGetMonitors(&count)
	check_error()
	//
	mut v_monitors := unsafe { []&Monitor{len: count} }
	for idx := 0; idx < count; idx++ {
		v_monitors[idx].data = unsafe { c_monitors[idx] }
	}
	return v_monitors
}

// get_primary_monitor returns the primary monitor
pub fn get_primary_monitor() &Monitor {
	raw_data := C.glfwGetPrimaryMonitor()
	check_error()
	//
	v_monitor := &Monitor{
		data: raw_data
	}
	//
	return v_monitor
}

// set_monitor_callback sets the monitor changed callback
pub fn set_monitor_callback(cb FnMonitor) FnMonitor {
	prev := C.glfwSetMonitorCallback(cb)
	check_error()
	return prev
}

// default_window_hints resets the window hints to their default values
pub fn default_window_hints() {
	C.glfwDefaultWindowHints()
	check_error()
}

// window_hint sets window hint
pub fn window_hint(hint int, value int) {
	C.glfwWindowHint(hint, value)
	check_error()
}

// window_hint_string sets window hint
pub fn window_hint_string(hint int, value string) {
	C.glfwWindowHintString(hint, value.str)
	check_error()
}

// poll_events polls queued events
pub fn poll_events() {
	C.glfwPollEvents()
	check_error()
}

// wait_events locks the thread until events arrive to the queue
pub fn wait_events() {
	C.glfwWaitEvents()
	check_error()
}

// set_wait_events_timeout sets time out for waiting events
pub fn set_wait_events_timeout(timeout f64) {
	C.glfwWaitEventsTimeout(timeout)
	check_error()
}

// post_empty_event posts an empty event
pub fn post_empty_event() {
	C.glfwPostEmptyEvent()
	check_error()
}

// is_raw_mouse_motion_supported return true if raw mouse motion is supported
pub fn is_raw_mouse_motion_supported() bool {
	ok := C.glfwRawMouseMotionSupported()
	check_error()
	return ok == glfw_true
}

// get_key_name returns a key name
pub fn get_key_name(key int, scan_code int) string {
	n := C.glfwGetKeyName(key, scan_code)
	check_error()
	return unsafe { n.vstring() }
}

// get_key_scan_code gets a key scan code
pub fn get_key_scan_code(key int) int {
	c := C.glfwGetKeyScancode(key)
	check_error()
	return c
}

// get_time gets the time since initialization or since
// last call to set_time
pub fn get_time() f64 {
	t := C.glfwGetTime()
	check_error()
	return t
}

// set_time sets the intenal time
pub fn set_time(time f64) {
	C.glfwSetTime(time)
	check_error()
}

// get_timer_value returns the value of the internal timer
pub fn get_timer_value() u64 {
	v := C.glfwGetTimerValue()
	check_error()
	return v
}

// get_timer_frequency returns the value of the intenal timer's frequency
pub fn get_timer_frequency() u64 {
	f := C.glfwGetTimerFrequency()
	check_error()
	return f
}

// swap_interval sets an interval for the swap
pub fn swap_interval(interval int) {
	C.glfwSwapInterval(interval)
	check_error()
}

// is_extension_supported returns true if an extension is supported
pub fn is_extension_supported(extension string) bool {
	ok := C.glfwExtensionSupported(extension.str)
	check_error()
	return ok == glfw_true
}

// get_proc_address returns the process address
pub fn get_proc_address(proc_name string) FnGLProc {
	adr := C.glfwGetProcAddress(proc_name.str)
	check_error()
	return adr
}

// is_vulkan_supported returns true if Vulkan is supported
pub fn is_vulkan_supported() bool {
	ok := C.glfwVulkanSupported()
	check_error()
	return ok == glfw_true
}

// get_required_instance_extensions returns the required instance extensions
pub fn get_required_instance_extensions() []string {
	count := u32(0)
	data := C.glfwGetRequiredInstanceExtensions(&count)
	check_error()
	//
	mut exts := []string{len: int(count)}
	for i := 0; i < count; i++ {
		exts[i] = unsafe { data[i].vstring() }
	}
	//
	return exts
}

// set_joystick_callback sets joystick callback
pub fn (j &Joystick) set_joystick_callback(cb FnJoystick) FnJoystick {
	prev := C.glfwSetJoystickCallback(cb)
	check_error()
	return prev
}

// update_gamepad_mapping updates the gamepad mappings
pub fn update_gamepad_mapping(mappings string) bool {
	ok := C.glfwUpdateGamepadMappings(mappings.str)
	check_error()
	return ok == glfw_true
}
