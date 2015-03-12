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
         	msg_type = event:attr("msg_type");
      	}
		if( msg_type eq "song" ) then {
			send_directive("sing") with song = foo;
		}
		fired{
			raise explicit event sung
  				with song = foo;
   		}
	}
	rule find_hymn{
		select when explicit sung
		pre{
			song = event:attr("song");
		}
		if(song.match(re#.*god.*#)) then {
			noop();
		}
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