ruleset fanCollection {
  meta {

    name "fan_collection"
    author "PicoLabs"
    description "fan_collection"

    use module b507199x5 alias wrangler
    
    logging on
    
    sharing on
    provides fan_states
  }

  global {
    fanStates = function (){
      // wrapper for fanA and fanB state calls
      // returns an jason object with fan states keyed to there names
      noop();
    };
    //private
    collectionEcis = function () {
        return = wrangler:subscriptions(unknown,"subscriber_role","fan_controller").klog(">>> All subscribed subscriptions >>> "); 
        raw_subs = return{"subscriptions"}; // array of subs
        ecis = raw_subs.map(function( subs ){
          r = subs.values().klog("subs.values(): ");
          v = r[0];
          v{"outbound_eci"}
          });
        ecis.klog("ecis: ")
      };
  }


/*
  rule fanOn { // dynamically 
    select when fan need_more_air
      foreach collectionEcis setting(i)
    pre {
      level = event:attr("level");// 1 or 2
    }
    if (i <= level ) then
    {
      noop();
      event:send({},)
    } 
    fired {

    }
  }
*/
  rule fanAOn {
    select when fan need_more_air level re#1# // turn on fan A
             or explicit need_more_air
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0].klog("ecis[0]: " ) },"fan","new_status")
        with attrs = {
          "status" : "on"
        };
    } 

  }

  rule fanBOn {
    select when fan need_more_air level re#2#  // turn on fan B
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[1] },"fan","new_status")
        with attrs = {
          "status" : "on"
        };
    } 
    always{
      raise explicit event "need_more_air"
        with level = 1;
    }
  }

  rule fanAOff {
    select when fan no_more_air level re#0#  // turn off fans
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "status" : "off"
        };
    } 
  }

  rule fanBOff {
    select when fan no_more_air level re#0# // turn off fans
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[1] },"fan","new_status")
        with attrs = {
          "status" : "off"
        };
    } 
  }

}