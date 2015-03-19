ruleset echo_ta {
  meta {
    name "echo"
    description <<
    echo
    >>
    author "adam"
    logging on
    sharing on
    provides hello
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
 
  }
  rule hello_world is active {
    select when echo hello
    send_directive("say") with
      something = "Hello World";
  }
    rule hello {
    select when echo hello_ta
    send_directive("say") with
      something = "Hello World";
  }
    rule message {
    select when echo message_ta
    send_directive("say") with
      something = event:attr("input");
  }
 
}