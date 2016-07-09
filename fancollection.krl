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

 rule levelZero {
    select when fan airflow level re#0# 
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "state" : "off"
        };
    }
    always{ 
      raise explicit event "fan_b_off"
          with level = 0;
    }
  }
  rule levelOne {
    select when fan airflow level re#1# // turn on fan A
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "state" : "on"
        };
    }
    always{ 
      raise fan event "fan_b_off"
          with level = 0;
    }
  }

  rule levelTwo {
    select when fan airflow level re#2# // turn on fan A
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "state" : "on"
        };
    }
    always{ 
      raise fan event "airflow"
          with level = 2;
    }
  }
  */
  rule fanAOn {
    select when fan airflow level re#1#  // turn on fan B
             or fan airflow level re#2# 
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "state" : "on"
        };
    } 
  }

  rule fanBOn {
    select when fan airflow level re#2#  // turn on fan B
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[1] },"fan","new_status")
        with attrs = {
          "state" : "on"
        };
    } 
  }

  rule fanAOff {
    select when fan airflow level re#0#  // turn off fans
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[0] },"fan","new_status")
        with attrs = {
          "state" : "off"
        };
    } 
  }

  rule fanBOff {
    select when fan airflow level re#0#
            or fan airflow level re#1#
    pre {
      ecis = collectionEcis();
    }
    {
      noop();
      event:send({"cid": ecis[1] },"fan","new_status")
        with attrs = {
          "state" : "off"
        };
    } 
  }

}