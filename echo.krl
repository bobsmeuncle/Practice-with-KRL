///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/echo/hello
///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/echo/message

ruleset echo {
	meta {  
		name "echo"
		description <<
		echo rule sets.
		>>
		author "adam burdett"
		logging off
	}

	rule hello{
		select when echo hello

		{
			send_directive("say") with something = "Hello World";
		}

	}
	rule message{
		select when echo message
		pre {
         	foo = event:attr("input");
      	}
		{
			send_directive("say") with something = foo;
		}

	}

	rule displayMEWOrking{
		select when pageview ".*" {
			notify("version" ,".1");

		}

	}
}