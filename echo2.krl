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
		select when echo message where (event:attr("msg_type") eq song)
		pre {
         	foo = event:attr("input");
      	}
		{
			send_directive("sing") with song = foo;
		}
		fired{
			raise explicit event sung
  				with song = foo;
   		}
	}
	rule find_hymn{
		select when explicit sung where event:attr("song").match(re#.*god.*#)
		noop();
		fired{
			raise explicit event found_hymn;
		}
  	}

	rule displayMEWOrking{
		select when pageview ".*" {
			notify("version" ,".2");

		}

	}
}