ruleset ServoExample {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ {"domain": "example","type":"tickServo"},
                               {"domain":"example","type":"setUpExample"}] }
  }

  rule TickServer {
    select when example tickServo
     pre{
        pw = (ent:pulseWidth.defaultsTo(1000) )
        increment = (pw >= 2000) => -100 | 
                    (pw <= 1000) => 100 | ent:increment.defaultsTo(100)
    }
     gpio:servoWrite(10,pw)
    always{
       ent:pulseWidth := pw + ent:increment.defaultsTo(100) ;
       ent:increment := increment
    }
  }
}
