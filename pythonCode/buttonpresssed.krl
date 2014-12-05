///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/pie/button

ruleset rasberryPie {
	meta {  
		name "FourSquare CheckIn"
		description <<
		button on pie pressed.
		>>
		author "adam burdett"
		logging on
	}

	rule process_button_press{
		select when pie button
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
			notify("fired?" , "6");
		}

	}
}