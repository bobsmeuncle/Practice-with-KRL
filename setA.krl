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
				"Raise_Event_To_Remote_Ruleset");
			raise_event("event_remote_ruleset")
			with app_id = "B"
			and parameters = {
				"callback_rid" : "A" ,
				"callback_evt" : "event_callback"
			}
		}
	}
	rule Catch_Event_Callback{
		select when web Catch_Event_Callback
		notify("Catch_Event_Callback","Received Callback Event!")
	}
}