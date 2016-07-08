ruleset manage_fleet {
  meta {
    name "manage fleet "
    description <<
A ruleset for the managing fleet
>>
    author "burdettadam the ta"
    logging on
    sharing on
    provides trips, short_trips, long_trips
 
  }
  /*
  
   */
  global {

    manage_fleet = function



    trips = function(){
     tps = ent:trips.klog("trips: ");
     tps;
    }
    long_trips = function (){  ent:long_trips; }

    short_trips = function(){ 
     Atrips = trips();
     short_trips_keys = (ent:trips.keys()).difference((ent:long_trips.keys())).klog("list of short trip keys: ");
     short_trips_return = Atrips.filter( function(k,v){
      short_trips_keys.any(function(x){x.klog("x: ") eq k.klog("k: ")});
     }).klog("filtered short_trips: ");
     short_trips_return;
    }

    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
  long_trip = 10;
  }

  rule create_vehicle {
    select when car new_vehicle
    pre{
          // name //pico
          // name //subscription
          // name_space
          // my_rule
          // your_role
          // target_eci // needs to be added to event:attrs 
          // channel_type
          // attributes - optional
          // rids // track_trips
    }{
    noop();
    }
    always{
        // create a new child 
        raise explicit nano_manager 'child_creation'
        attributes event:attrs();
        // create a subscription , other rule will have to catch this and accept the subscription. 
        raise explicit nano_manager 'subscription'
        attributes event:attrs();
        // install track_trips 
        raise explicit nano_manager 'install_rulesets_requested'
        attributes event:attrs();
    }
  }


   rule manage_fleet {
    select when explicit found_long_trip
    pre{
      mileage = event:attr("mileage");
      timeStamp = time:now()
    }
    {
      noop();
    }
    always{
      set ent:long_trips{timeStamp} mileage;
    }
  }


    rule createChild {
    select when nano_manager child_creation
    
    pre {
      myEci = meta:eci();
      
      name = event:attr("name").defaultsTo("", standardError("no name passed"));
      
      newPico = (name eq "") => "" | picoFactory(myEci, []); // breaks the rules, mutates.............
    }

    if (name neq "") then
    {
      event:send({"eci":newPico}, "nano_manager", "child_created")
        with attrs = {
          "name" : name
        }
    }
    
    fired {
      log(standardOut("pico created with name #{name}"));
    }
    else
    {
      log "no name passed for new child";
    }
  }
   
  rule initializeChild {
    select when nano_manager child_created
    
    pre {
      name = event:attr("name");
      //attrs = event:attr("attributes").decode();
      //protos = event:attr("prototypes").decode();
    }
    
    {
      noop();
    }
    
    fired {
      set ent:name name;
      //set ent:attributes attrs;
      //set ent:prototypes protos;
    }
  }
  /*
        ----AUTO SUBSCRIBE FROM JOIN FUSE ---
        Adam- recreate this using next-gen cloud os.
        place in cook and add illistrations.
        create a subscriptions page as well.
        copy old subscription page and update it. discribe the mechanics of the process.
  */
//https://github.com/kynetx/Fuse-API/blob/master/api/fuse_vehicle.krl
    


    rule auto_approve_pending_subscriptions {
        select when cloudos subscriptionRequestPending
           namespace re/fuse-meta/gi

        {
            noop();
        }

        fired {
            raise cloudos event subscriptionRequestApproved
                with eventChannel = event:attr("eventChannel")
                and  _api = "sky";
        }
    }
    //https://github.com/kynetx/Fuse-API/blob/master/api/fuse_fleet.krl

  rule create_vehicle_check {
        select when explicit vehicle_creation_ok
        pre {
    name = event:attr("name") || "Vehicle-"+math:random(99999);
          pico = common:factory({"schema": "Vehicle", "role": "vehicle"}, meta:eci());
          channel = pico{"authChannel"};
          vehicle = {
            "cid": channel
          };
    pico_id = "Fleet-vehicle"+ random:uuid();
        }
  if (pico{"authChannel"} neq "none") then
        {

    // depend on this directive name and id
    send_directive("vehicle_created") with
            cid = channel and
      id = pico_id;

          // tell the vehicle pico to take care of the rest of the initialization.
          event:send(vehicle, "fuse", "new_vehicle") with 
            attrs = (event:attrs()).put({"fleet_channel": meta:eci(),
                         "schema":  "Vehicle",
                     "_async": 0    // we want this to be complete before we try to subscribe below
              });

        } 

        fired {

    // make it a "pico" in CloudOS eyes
    raise cloudos event picoAttrsSet
            with picoChannel = channel
             and picoName = name
             and picoPhoto = event:attr("photo") || common:vehicle_photo 
             and picoId = pico_id
             and _api = "sky";

    // subscribe to the new vehicle
          raise cloudos event "subscribe"
            with namespace = common:namespace()
             and  relationship = "Vehicle-Fleet"
             and  channelName = pico_id
             and  targetChannel = channel
             and  _api = "sky";

          log ">>> VEHICLE CHANNEL <<<<";
          log "Pico created for vehicle: " + pico.encode();

        } else {
          log ">>> VEHICLE CHANNEL <<<<";
          log "Pico NOT CREATED for vehicle " + name;
  }
    }


}