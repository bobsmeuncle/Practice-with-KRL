///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/raspberrypie/button

ruleset rasberryPie {
	meta {  
		name "raspberrypie"
		description <<
		raspberrypie rule sets.
		>>
		author "adam burdett"
		logging off
	}

	rule button_press{
		select when raspberrypie button

		{
			send_directive("blink your light") with blinks = math:random(6);
		}

	}

	rule displayMEWOrking{
		select when pageview ".*" {
			notify("version" ,"9");

		}

	}
}