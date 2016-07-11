ruleset closetCollection {
  meta {

    name "closet_collection"
    author "PicoLabs"
    description "General rules for closet control"

    use module b507199x5 alias wrangler
    
    logging on
    
    sharing on
    provides fan_states,outside_temp,inside_temp,temp_thresholds
  }

  global {
    fan_states = function (){
      ecis = Ecis("subscriber_role","fan_level_driver");
      wrangler:skyQuery(ecis[0],meta:host(),fanStates,{})
    };
    outside_temp = function (){
      ecis = Ecis("subscriber_role","transmit_outside_temp");
      wrangler:skyQuery(ecis[0],meta:host(),lastTemperature,{})
    };
    inside_temp = function (){
      ecis = Ecis("subscriber_role","transmit_inside_temp");
      wrangler:skyQuery(ecis[0],meta:host(),lastTemperature,{})
    };
    temp_thresholds = function (){
      ecis = Ecis("subscriber_role","transmit_inside_temp");
      wrangler:skyQuery(ecis[0],meta:host(),thresholds,{ threshold_type : "inside_temp_threshold" })
    };
    lower_threshold = function (){
      thresholds = temp_thresholds();
      thresholds_lower = thresholds{["limits","lower"]};
      thresholds_lower
    };
    upper_threshold = function (){
      thresholds = temp_thresholds();
      thresholds_upper = thresholds{["limits","upper"]};
      thresholds_upper
    };
    //private
    Ecis = function (collection,collection_value) { 
      return = wrangler:subscriptions(unknown,collection,collection_value); 
      raw_subs = return{"subscriptions"}; // array of subs
      ecis = raw_subs.map(function( subs ){
        r = subs.values().klog("subs.values(): ");
        v = r[0];
        v{"outbound_eci"}
        });
      ecis.klog("ecis: ")
    };

    fan_collection_eci = function (){
      ecis = Ecis("subscriber_role","fan_level_driver");
      ecis
    };
}

  rule logicallyFanOn {
    select when esproto threshold_violation where threshold eq upper_threshold()
    pre {
      outside = outside_temp().klog("outside temp: ");
      inside = inside_temp().klog("inside temp: ");
      thresholds = temp_thresholds().klog("inside temp thresholds: ");
      //thresholds_lower = thresholds{["limits","lower"]};
      thresholds_upper = thresholds{["limits","upper"]};
      //temp_diff = inside - outside ;
      thresholds_diff = inside - thresholds_upper;
      airflow_level = (thresholds_diff > 3) => 2 | 1;
      fan_driver = fan_collection_eci();
    }
    if (inside > outside) then
    {
      event:send({"cid": fan_driver[0] },"fan","airflow")
        with attrs = {
          "level" : airflow_level
        };
    } // fan is off
    fired {
      log "turning on fans with airflow level @ " + airflow_level;
    }
    else {
      log "failed to turn on its to hot outside."
    }
  }
/*
    rule logicallyFanOff {
    select when esproto threshold_violation where threshold eq lower_threshold()
    pre {
      outside = outside_temp().klog("outside temp: ");
      inside = inside_temp().klog("inside temp: ");
      airflow_level = 0;
      fan_driver = fan_collection_eci();
    }
    {
      event:send({"cid": fan_driver[0] },"fan","airflow")
        with attrs = {
          "level" : airflow_level
        };
    } // fan is off
    fired {
      log "turning off fans with airflow level @ " + airflow_level;
    }
    else {
    }
  }
*/
}