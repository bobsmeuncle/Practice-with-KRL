ruleset trip_store {
  meta {
    name "trip store"
    description <<
A ruleset for the storing trips
>>
    author "burdettadam the ta"
    logging on
    sharing on
    provides trips, short_trips, long_trips
 
  }
  global {
    trips = function(){
     tps = ent:trips.klog("trips: ");
     tps;
    }
    long_trips = function (){  ent:long_trips; }

    short_trips = function(){ 
     Atrips = trips().klog("all trips: ");
     short_trips_keys = (ent:trips.keys()).difference((ent:long_trips.keys())).klog("list of short trip keys: ");
     short_trips_return = Atrips.filter( function(k,v){
      short_trips_keys.all(function(x){x eq k});
     }).klog("filtered short_trips: ");
     short_trips_return;
    }

    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
  long_trip = 10;
  }
  rule collect_trips {
    select when explicit trip_processed
    pre{
      time_stamp = time:now()
    }{
    noop();
    }
    always{
      set ent:trips{time_stamp} mileage;
    }
  }
   rule collect_long_trips {
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
    rule clear_trips {
    select when car trip_reset
    pre{
      mileage = event:attr("mileage");

    }
    {
      noop();
    }
    always{
      clear ent:long_trips;
      clear ent:trips;
    }
  }
}