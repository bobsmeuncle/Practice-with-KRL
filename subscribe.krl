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
    provides hello 
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
    channel = function (name){ // eci from name // use function from wrangler
      my_channels = wrangler_api:channels();
      channel_list = my_channels{"channels"}.defaultsTo("no Channel","no channel found, by channels");
      filtered_channels = channel_list.filter(function(channel){
        (channel{'name'} eq name);}); 
      result = filtered_channels.head().defaultsTo("","no channel found, by .head()");
      (result{'cid'});
    }


  }
  // create well known eci in child
  rule createWellKnown is active{
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

  rule wellKnownCreated is active {
    select when wrangler channel_created where channel_name eq "Well_Known" && channel_type eq "Pico_Tutorial"
    pre {
        // find parant 
        parent_results = wrangler_api:parent();
        parent = parent_results{'parent'};
        parent_eci = parent[0].klog("parent eci: ");
       // name_results = wrangler_api:name();
       // name = name_results{'picoName'};
        well_known_eci = channel("Well_Known").klog("well known eci: ");
        init_attributes = event:attrs();
        attributes = init_attributes
                                    //.put(["child_name"],name)
                                    .put(["well_known"],well_known_eci)
                                    ;
    }
    {
      event:send({"cid":"D0647BAC-AF52-11E5-9D3E-A37B040ECC4C".klog("parent_eci: ")}, "subscriptions", "child_well_known_created")  
      //event:send({"cid":parent_eci.klog("parent_eci: ")}, "subscriptions", "child_well_known_created")  
        with attrs = attributes.klog("event:send attrs: ");
    }
    always {
      log("parent notified of well known channel");
    }
  }

 }

