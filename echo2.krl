///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/echo/hello
///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/echo/message

ruleset echo2 {
	meta {  
		name "echo"
		description <<
		echo rule sets.
		>>
		author "adam burdett"
		logging off
	}

	rule message{
		select when echo message
		pre {
         	foo = event:attr("input");
      	}
		{
			send_directive("sing") with singing = foo;
		}

	}

	rule displayMEWOrking{
		select when pageview ".*" {
			notify("version" ,".2");

		}

	}
}