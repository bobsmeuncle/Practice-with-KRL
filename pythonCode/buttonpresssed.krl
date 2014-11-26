//Name:Foursquare Checkins
//ID:FC64E88C-6F51-11E4-8766-859FE71C24E1
///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/pie/buttonPressed

ruleset rasberryPie {
	meta {  
		name "button pressed on pie"
		description <<
		button on pie pressed.
		>>
		author "adam burdett"
		logging off

		use module a169x701 alias CloudRain
		use module a41x186  alias SquareTag
	}

	global {

	}

	rule process_button_press{
		select when pie buttonPressed
				send_directive("blink your light") with blinks = 5;

	}

}