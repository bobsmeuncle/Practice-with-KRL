ruleset Gossip {
  meta {
    name "Gossip protocal"
    description <<
ruleset for Gossip protocal.
>>
    author "Adam Burdett"
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

  rule hello_world {
    select when echo hello
  pre{
    name = event:attr("name").klog("our passed in Name: ");
  }{
    send_directive("say") with
      something = "Hello #{name}";
  }
    always {
      log "LOG says Hello " + name ;
    }
  }
  rule push_message {
    select when gossip push_message
  pre{
    name = event:attr("message").klog("message: ");
    //get random picos to send to
  }{
    // map on random picos and send mesage to them
    send_directive("say") with
      something = "Hello #{name}";
  }
    always {
      log "LOG says Hello " + name ;
    }
  }
}