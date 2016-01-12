ruleset trip_store {
  meta {
    name "trip store"
    description <<
A ruleset for the storing trips
>>
    author "burdettadam the ta"
    logging on
    sharing on
    provides hello
 
  }
  global {
    trips = function(){ ent:trips; }
    long_trips = function (){  ent:long_trips; }

    short_trips = function(){ 
      noop();
     // Atrips = trips();
    //  AtripSet = Atrips.keys();
     // Ltrips = long_trips();
     // LtripSet = long_trips.keys();
      result = ent:trips.keys().difference(ent:long_trips.keys());
      result;
    }

    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
  long_trip = 10;
  }
  rule collect_trips {
    select when explicit processed_trip
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