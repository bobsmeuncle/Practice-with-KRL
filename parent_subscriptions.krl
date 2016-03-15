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
    //provides hello 
 
  }
  global {
    child = function(name) {
      child_list_results = wrangler_api:children();
      child_list = child_list_results{'children'}.klog("children: ");
      children_with_name = child_list.filter( function (tuple){
        (wrangler_api:skyQuery(tuple[0],wrangler_api,name,"") eq name)
        ;});
      child = children_with_name.head();
      child.klog("matched child: ");
    };

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
    select when subscriptions child_well_known_created well_known re#(.*)# setting (sibling_well_known_eci) 
            and subscriptions child_well_known_created well_known re#(.*)# setting (child_well_known_eci)

    pre {
      //sibling_eci = child(children[0]).klog("sibling_eci: ");
      //sibling_eci = event:attr("well_known_eci").klog("sibling_eci: ");
      //child_eci = ent:child.defaultsTo(0,"child_eci variable is not initialize yet");
      //child_eci = child(children[1]).klog("child_eci");
      // get well_known_eci
      //well_known_channel = wrangler_api:skyQuery(sibling_eci,wrangler_api,channel,"Well_Known");
      //sibling_well_known_eci = well_known_channel{'cid'}.klog("sibling_well_known_eci: ");
      //well_known_channel = wrangler_api:skyQuery(child_eci,wrangler_api,channel,"Well_Known");
      //child_well_known_eci = well_known_channel{'cid'}.klog("child_well_known_eci: ");

      attributes = {}.put(["name"],"brothers")
                      .put(["name_space"],"Tutorial_Subscriptions")
                      .put(["my_role"],"BrotherB")
                      .put(["your_role"],"BrotherA")
                      .put(["target_eci"],child_well_known_eci.klog("target Eci: "))
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attrs"],"success")
                      ;
    }
    {
      event:send({"cid":sibling_well_known_eci.klog("sibling_well_known_eci: ")}, "wrangler", "subscription")  
        with attrs = attributes.klog("attributes for subscription: ");
    }
    always{ 
      log("send child well known " +sibling_well_known_eci+ "subscription event for child well known "+child_well_known_eci); 
    }
  }

  // Accept Subscription


 }

