ruleset io.manifold.owner {
  meta {
    use module io.picolabs.wrangler alias wrangler
    shares __testing, getManifoldPico
  }
  global {
    __testing =
      { "queries": [ { "name": "__testing", "name":"getManifoldPico" } ],
        "events": [ { "domain": "manifold", "type": "channel_needed",
                      "attrs": [ "eci_to_manifold_child" ] } ] }

    config={"pico_name" : "Manifold", "URI" : ["io.manifold.manifold.krl"], "rids": ["io.manifold.manifold"]};

    getManifoldPico = function(){
      wrangler:children(config{"pico_name"}) // wrangler will return null on invalid...
    }

  }

  rule channel_needed {
    select when manifold channel_needed
    pre {
      child = getManifoldPico();
    }
    if child then every {
      engine:newChannel(child.id,config{"pico_name"},"App") // look up how to pass parameters
        setting(new_channel)
      send_directive("manifold new channel",{
        "eci": new_channel.id.klog("new eci created:")})
    }
  }

  rule initialization {
    select when wrangler ruleset_added  // HEY!!!! make sure this corresponds with wrangler install rid event
    pre {
      manifoldPico =  getManifoldPico()
    }
    if not manifoldPico then
      engine:registerRuleset(config{"URI"}.klog("URI used:"),meta:rulesetURI.klog("Path used")).klog("attempted registration ")
    fired {
      raise wrangler event "new_child_request" // HEY HEY!!!! check event api
        attributes { "name": config{"pico_name"}, "color": "#7FFFD4", "rids": config{"rids"} } // check child creation api
    }
  }

}
