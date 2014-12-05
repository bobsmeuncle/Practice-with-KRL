///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/pie/button

ruleset rasberryPie {
	meta {  
		name "FourSquare CheckIn"
		description <<
		Checkin In With Foursquare
		>>
		author "adam burdett"
		logging off

		use module a169x701 alias CloudRain
		use module a41x186  alias SquareTag
	}

	rule process_button_press{
		select when foursquare check
		//select when raspberrypie button
		pre{
			adam = 26;
		}
		{
			send_directive("blink your light") with blinks = "5";
		}
		fired{
			set ent:adam adam;
		}
	}

	rule displayMEWOrking{
		select when pageview ".*" {
			notify("Working?" ,"8");
			notify("fired?" ,ent:adam);
		}

	}
}