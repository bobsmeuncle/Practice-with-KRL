ruleset track_trips {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "burdettadam the ta"
    logging on
    sharing on
    provides hello
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
  long_trip = 10;
  }
  rule process_trip {
    select when car new_trip
    pre{
      mileage = event:attr("mileage");
    }{
    send_directive("trip") with
      trip_length = mileage;
    }
    always{
      raise explicit event 'trip_processed'
        attributes event:attrs();
    }
  }
   rule find_long_trips {
    select when explicit trip_processed
    pre{
      mileage = event:attr("mileage");
    }
    if( mileage > long_trip) then {
      noop();
    }
    fired{
      raise explicit event 'found_long_trip'
        attributes event:attrs();
    }
  }
}