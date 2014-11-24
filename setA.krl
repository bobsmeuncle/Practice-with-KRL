//explicit event example set A
ruleset A {
	meta {
		name "set A"
		description <<
		set A with explicit events.
		>>
		author ""
		logging on
	}

	global {
	}
	rule Raise_Event_Action {
		select when pageview ".*"
		{
			notify("Kynetx Event Walkabout",
				"Raise_Event_To_Remote_Ruleset") with sticky = true;
			raise_event("event_remote_ruleset")
			with app_id = b506607x8
			and parameters = {
				"callback_rid" : "b506607x7" ,
				"callback_evt" : "event_callback"
			}
		}
	}
	rule Catch_Event_Callback{
		select when web Catch_Event_Callback
		notify("Catch_Event_Callback","Received Callback Event!") with sticky = true
	}
}