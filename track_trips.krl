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
 
  }
  rule process_trip {
    select when echo message
    pre{
      mileage = event:attr("mileage")
    }
    send_directive("trip") with
      trip_length = mileage;
  }
 
}