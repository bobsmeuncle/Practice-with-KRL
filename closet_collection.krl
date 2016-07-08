ruleset closetCollection {
  meta {

    name "closet_collection"
    author "PicoLabs"
    description "General rules for closet control"

    use module b507199x5 alias wrangler
    
    logging on
    
    sharing on
    provides fan_state
  }

  global {
    fan_state = function (){
      ent:fan_state;
    };
    //private
}

  rule fanOn {
    select when fan turn_on
    pre {}
   // if(ent:fan_state eq 0) then
    {
      http:put(ent:on_api);// wont work with out https

    } // fan is off
    always {
      log "turning on fan @ " + ent:on_api;
      set ent:fan_state 1;
    }
  //  else {
  //    log "fan is already on."
  //  }
  }

}