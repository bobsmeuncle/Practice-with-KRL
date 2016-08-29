ruleset voting {
  meta {
    name "voice of the children"
    description <<
A ruleset to deminstrate app varibles by implamenting a voting service.
>>
    author "Adam Burdett"
    logging on
    sharing on
    provides hello
 
  }
  global {
    votes = function() {
      votes = app:votes;
      votes;
    };
  }
  /*
    votes : {
        party :{
          tedrub: <int>
          burdett: <int>
        } 
    }
   */

  rule store_vote {
    select when explicit 
    pre{
      party = event:attr("party").klog("party : ");
      candidate = event:attr("candidate").klog("1 vote for : ");
     
    }{
      noop();
    }
    always{
      set app:votes{[party,candidate]} votes{[party,candidate]} + 1;
    }
  }

 }

