ruleset esproto_device {
  meta {

    name "esproto_device"
    author "PicoLabs"
    description "General rules for ESProto Fan control system"

    use module b507199x5 alias wrangler
    
    logging on
    
    sharing on
    provides thresholds, box_fan_state
  }

  global {

    // public
    thresholds = function(threshold_type) {
      threshold_type.isnull() => ent:thresholds
                               | ent:thresholds{threshold_type}
    };

    box_fan_state = function() {
      ent:fan_state;
    };
    //private
    event_map = {
      "new_temperature_reading" : "temperature",
      "new_humidity_reading" : "humidity",
      "new_pressure_reading" : "pressure"
    };

    reading_map = {
      "temperature": "temperatureF",
      "humidity": "humidity",
      "pressure": "pressure"
    };
}

  // rule to save thresholds
  rule save_threshold {
    select when esproto new_threshold
    pre {
      threshold_type = event:attr("threshold_type");
      threshold_value = {"limits": {"upper": event:attr("upper_limit"),
                                    "lower": event:attr("lower_limit")
				                            }
                        };
      }
    if(not threshold_type.isnull()) then noop();
    fired {
      log "Setting threshold value for #{threshold_type}";
      set ent:thresholds{threshold_type} threshold_value;
      set ent:fan_state 0;
    }
  }

  rule check_threshold {
    select when esproto new_temperature_reading
    //foreach event:attr("readings") setting (reading)
      pre {

        // thresholds
	threshold_type = "temperature"; 
	threshold_map = thresholds(threshold_type).klog("Thresholds: ");
	lower_threshold = threshold_map{["limits","lower"]}.klog("Lower threshold: ");
	upper_threshold = threshold_map{["limits","upper"]};

        // sensor readings
	//data = reading.klog("Reading from #{threshold_type}: ");
  data = event:attr("temp");
	//reading_value = data{reading_map{threshold_type}}.klog("Reading value for #{threshold_type}: ");
	//sensor_name = data{"name"}.klog("Name of sensor: ");

        // decide
	//under = reading_value < lower_threshold;
  //over = upper_threshold < reading_value;
	over = upper_threshold < data;
	//msg = under => "#{threshold_type} is under threshold of #{lower_threshold}"
	//    | over  => "#{threshold_type} is over threshold of #{upper_threshold}"
	//   |          "";
      }
      if( over ) then noop();
      fired {
	       set ent:fan_state 1;   
      }
      else {
        set ent:fan_state 0;
      }
  }

}