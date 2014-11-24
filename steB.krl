//explicit event example set b
ruleset B {
	meta {
		name "set B"
		description <<
		set B with explicit events.
		>>
		author ""
		logging on
	}

	global {
	}
	rule Catch_Remote_Event {
		select when web event_remote_ruleset
		pre{
			callback_rid = event:attr("callback_rid");
			callback_evt = event:attr("callback_evt");
			}{
				notify("Catch_Remote_Event",
					"Received from remote Ruleset!") with sticky = true;
				notify("Now Raise Callback","rid: #{callback_rid} name: #{callback_evt}") with sticky = true;
				raise_event(event_callback)
				with app_id = callback_rid;
			}
		}
	}