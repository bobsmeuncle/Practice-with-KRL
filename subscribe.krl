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
    channel = function (name){ // eci from name
      my_channels = channels();
      channel_list = my_channels{"channels"}.defaultsTo("no Channel",standardOut("no channel found, by channels"));
      filtered_channels = channel_list.filter(function(channel){
        (channel{'name'} eq name);}); 
      result = filtered_channels.head().defaultsTo("",standardError("no channel found, by .head()"));
      (result{'cid'});
    }


  }
  // create well known eci in child
  rule createWellKnown {
    select when wrangler init_eventss
    pre {
      attr = {}.put(["channel_name"],"Well_Known")
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attributes"],"")
                      .put(["policy"],"")
                      ;
    }
    {
      noop();
     //   event:send({"cid": meta:eci() }, wrangler, channel_creation_requested)  
     //   with attrs = attr;
    }
    always {
      log("created wellknown channel");
      raise wrangler event "channel_creation_requested" // init prototype  // rule in pds needs to be created.
            attributes attr
    }
  }

  rule wellKnownCreated {
    select when wrangler channel_created where channel_name eq "Well_Known" 
          and wrangler channel_created where channel_type eq "Pico_Tutorial"
    pre {
        // find parant 
        parant_results = wrangler_api:parent();
        parent = parant_results{'parent'};
        parent_eci = parent[0].klog("parent_eci: ");
        well_known_eci = channel("Well_Known").klog("well known eci: ");
        attributes = event:attrs().put(["well_known_eci"],well_known_eci);
    }
    {
      event:send({"cid":parent_eci}, subscriptions, chiled_well_known_created)  
        with attrs = attributes;
    }
    always {
      log("parent notified of well known channel");
    }
  }

 }

