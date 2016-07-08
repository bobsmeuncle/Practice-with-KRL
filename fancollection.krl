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
    collectionSubscriptions = function () {
        return = wrangler:subscriptions(unknown,"status","subscribed").klog(">>> All subscribed subscriptions >>> "); 
        raw_subs = return{"subscriptions"};
        subs = raw_subs.filter(function(k,v){v{"name_space"} eq "closet_collection" && v{"subscriber_role"} eq "fan_controller"});
        subs.klog("Subscriptions: ").defaultsTo({})// returns a map of desired subscriptions
      };
    fanChannels = function () {
      subs = collectionSubscriptions();
      attributes = subs.values().klog("values: "); // array of maps
      channels = attributes.map( function(x){ x{"outbound_eci"} }); // array of eci's
      channels.klog("channels : ")
    }
  }


/*
  rule fanOn { // dynamically 
    select when fan need_more_air
      foreach fanChannels setting(i)
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
    select when fan need_more_air where level == 1 // turn on fan A
             or explicit need_more_air
    pre {
      ecis = fanChannels();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "status" : "on"
        };
    } 

  }

  rule fanBOn {
    select when fan need_more_air where level == 2 // turn on fan B
    pre {
      ecis = fanChannels();
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
    select when fan no_more_air where level == 0 // turn off fans
    pre {
      ecis = fanChannels();
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
    select when fan no_more_air where level == 0 // turn off fans
    pre {
      ecis = fanChannels();
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