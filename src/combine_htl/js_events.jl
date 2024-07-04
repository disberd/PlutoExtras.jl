## Automatic Event Listeners - DualScript ##

_events_listeners_preamble = let
	body = ScriptContent("""	/* # JS Listeners Preamble added by PlutoExtras */
	// Array where all the event listeners are stored
	const _events_listeners_ = []

	// Function that can be called to add events listeners within the script
	function addScriptEventListeners(element, listeners) {
		if (listeners.constructor != Object) {
			error('Only objects with keys as event names and values as listener functions are supported')
		}
		_events_listeners_.push({element, listeners})
	}
	/* # JS Listeners Preamble added by PlutoExtras */
""", false) # We for this to avoid detecting the listeners and avoid stripping newlines
	ds = DualScript(PlutoScript(body), NormalScript(body)) |> PrintToScript
end

_events_listeners_postamble = let
	body = ScriptContent("""

	/* # JS Listeners Postamble added by PlutoExtras */
	// Assign the various events listeners defined within the script
	for (const item of _events_listeners_) {
		const { element, listeners } = item
		for (const [name, func] of _.entries(listeners)) {
  			element.addEventListener(name, func)
		}
	}
	/* # JS Listeners Postamble added by PlutoExtras */""",
	false)
	invalidation = ScriptContent("""
	/* # JS Listeners invalidation added by PlutoExtras */
	// Remove the events listeners during invalidation
	for (const item of _events_listeners_) {
		const { element, listeners } = item
		for (const [name, func] of _.entries(listeners)) {
			element.removeEventListener(name, func)
		}
	}
	/* # JS Listeners invalidation added by PlutoExtras */
"""; addedEventListeners = false)
	ds = DualScript(PlutoScript(body, invalidation), NormalScript(body)) |> PrintToScript
end