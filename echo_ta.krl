ruleset see_songs {
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
  rule songs_ta {
    select when echo message_ta msg_type re#song# 
    send_directive("sing") with
      song = event:attr("input");
    
  always{
      raise explicit event sung
          with song = event:attr("input");
    }
  }
  rule find_hymn_ta{
    select when explicit sung
    pre{
      song = event:attr("song");
    }
    if(song.match(re#.*god.*#)) then {
      noop();
    }
    fired{
      raise explicit event found_hymn
        with hymn = song;
    }
    }

 
}