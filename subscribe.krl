ruleset subscriptions {
  meta {
    name "subscriptions"
    description <<
A rulest to show how to create subscriptions.
>>
    author "adam burdett"
    use module  b507199x5 alias wrangler_api
    logging on
    sharing on
    //provides 
 
  }
  global {


  }
  rule childTOParent {
    select when wrangler init_events
    pre {
      parent_eci = event:attr("parent_eci"); 
       attrs = {}.put(["name"],"Family")
                      .put(["name_space"],"Tutorial_Subscriptions")
                      .put(["my_role"],"Child")
                      .put(["your_role"],"Parent")
                      .put(["target_eci"],parent_eci.klog("target Eci: "))
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attrs"],"success")
                      ;
    }
    {
     noop();
      //event:send({"cid":parent_eci.klog("parent eci: ")}, "wrangler", "subscription")  
      //  with attrs = attributes.klog("attributes for subscription: ");
    }
    always {
      raise wrangler event "subscription"
        with attributes = attrs;
      log("created wellknown channel");
    }
  }

  /*// create well known eci in child
  rule createWellKnown {
    select when wrangler init_events
    pre {
      attr = {}.put(["channel_name"],"Well_Known")
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attributes"],"")
                      .put(["policy"],"")
                      ;
    }
    {
        event:send({"cid": meta:eci()}, "wrangler", "channel_creation_requested")  
        with attrs = attr.klog("attributes: ");
    }
    always {
      log("created wellknown channel");
    }
  }

  rule wellKnownCreated {
    select when wrangler channel_created where channel_name eq "Well_Known" && channel_type eq "Pico_Tutorial"
    pre {
        // find parant 
        parent_results = wrangler_api:parent();
        parent = parent_results{'parent'};
        parent_eci = parent[0].klog("parent eci: ");
       // name_results = wrangler_api:name();
       // name = name_results{'picoName'};
        well_known = wrangler_api:channel("Well_Known").klog("well known: ");
        well_known_eci = well_known{"cid"};
        init_attributes = event:attrs();
        attributes = init_attributes
                                    //.put(["child_name"],name)
                                    .put(["well_known"],well_known_eci)
                                    ;
    }
    {
      //event:send({"cid":"D0647BAC-AF52-11E5-9D3E-A37B040ECC4C".klog("parent_eci: ")}, "subscriptions", "child_well_known_created")  
      event:send({"cid":parent_eci.klog("parent_eci: ")}, "subscriptions", "child_well_known_created")  
        with attrs = attributes.klog("event:send attrs: ");
    }
    always {
      log("parent notified of well known channel");
    }
  }

  rule autoAccept {
    select when wrangler inbound_pending_subscription_added 
    pre{
      attributes = event:attrs().klog("subcription :");
      }
      {
      noop();
      }
    always{
      raise wrangler event 'pending_subscription_approval'
          attributes attributes;        
          log("auto accepted subcription.");
    }
  } */
 }

