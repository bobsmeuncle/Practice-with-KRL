ruleset fanCollection {
  meta {

    name "fan_collection"
    author "PicoLabs"
    description ""

    use module b507199x5 alias wrangler
    
    logging on
    
    sharing on
    provides fan_states
  }

  global {
    fan_states = function (){
      // rapper for fanA and fanB state calls
      // returns an jason object with fan states keyed to there names
    };
    //private
}

/// logic rule 
// on violation event check outside temp and if cooler turn on fan event. 
// 



  rule fansOn {
    select when esproto threshold_violation // with upper_threshold
    pre {}
    {
      //event send turn on fan to all fans 
    } 
  }


  rule fanOff {
    select when esproto threshold_violation // with lower_threshold
    pre {}
    {
      // event send turn off all fans 
    } 
    fired {
      log "turning off fan @ " + ent:off_api;
      set ent:fan_state 1;
    }
  }

  rule updateApi {
    select when collection fan_update_api
    pre {
      api_on = event:attr("api_on");
      api_off = event:attr("api_off");
      state = event:attr("state").defaultsTo(0,"defaulted To off");
      }
    {
      // event send fan update_api to all fans with all attributes passed.
    }
  }

}