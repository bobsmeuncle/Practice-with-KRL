ruleset subscriptions {
  meta {
    name "subscriptions"
    description <<
A rulest to show how to create subscriptions.
>>
    author "adam burdett"
    use module  b507199x5 alias wrangler
    logging on
    sharing on
    //provides hello 
 
  }
  global {

    children = ["ChildC","ChildD"];  // children to be created

  }


  // create 2 children 
    rule createChildren{
    select when subscriptions automate
    foreach children setting (child)
    pre{
      attributes = {}
                              .put(["Prototype_rids"],"b507706x5.dev") // ; seperated rulesets the child needs installed at creation
                              .put(["name"],child) // name for child
                              ;
    }
    {
      event:send({"cid":meta:eci()}, "wrangler", "child_creation")  // wrangler api event.
      with attrs = attributes.klog("attributes: "); // needs a name attribute for child
    }
    always{
      log("create child for " + child);
    }
  }


  // Request Subscription
  rule requestSubscription { // ruleset for parent 
    select when subscriptions chiled_well_known_created
    pre {
      sibling_eci = event:attr("well_known_eci").klog("sibling_eci: ");
      child_eci = ent:child.defaultsTo(0,"child_eci variable is not initialize yet");
      attributes = {}.put(["name"],"brothers")
                      .put(["name_space"],"Tutorial_Subscriptions")
                      .put(["my_role"],"BrotherB")
                      .put(["your_role"],"BrotherA")
                      .put(["target_eci"],child_eci)
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attrs"],"success")
                      ;
    }
    if (child_eci neq 0) then 
    {// if some one to send invite exist, send request for sibling_eci to raise
      event:send({"cid":sibling_eci}, "wrangler", "subscription")  
        with attrs = attributes.klog("attributes for subscription: ");
    }
    fired { // send request events 
    set ent:child other_child;
    }
    else{ // initialize child to send subscriptions request to next time this rule fires. 
    set ent:child other_child;
    }
  }

  rule clearChild { 
    select when subscriptions clear_child
    pre {

    }
    {
      noop();
    }
    always {  
    clear ent:child;
    }
  }

  // Accept Subscription


 }

