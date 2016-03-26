ruleset trip_store {
    meta {
        name "Trip Store"
        description <<
        A Trip Store
        >>
        author "Colby Clark"
        use module  b507199x5 alias wranglerOS
        
        logging on
        sharing on
        provides trips, long_trips, short_trips
    }

    global {
        long_trip = 500;

        trips = function()
        {
            processed_trips = ent:processed_trips || [];
            processed_trips
        }

        long_trips = function()
        {
            long_trips = ent:long_trips;
            long_trips
        }

        short_trips = function()
        {
            processed_trips = ent:processed_trips;
            long_trips = ent:long_trips;
            short_trips = processed_trips.filter( function(value) {
                long_trips.none( function(long_value) {
                    value{"mileage"} eq long_value{"mileage"} && value{"timestamp"} eq long_value{"timestamp"}
                    })
                });
            short_trips
        }
    }

    rule process_trip {
        select when car new_trip
        pre {
            mileage = event:attr("mileage").klog("Process Trip Mileage: ");
        }
        
        fired {
            raise explicit event 'trip_processed'
                attributes event:attrs();
        }
    }

    rule find_long_trips {
        select when explicit trip_processed
        pre {
            mileage = event:attr("mileage").klog("Find Long Trips Mileage: ");
        }
        if (mileage > long_trip) then {
            send_directive("long_trip") with
                trip_length = mileage
        }
        fired {
            raise explicit event 'found_long_trip'
                attributes event:attrs();
            log "in the fired block with mileage " + mileage + " and long_trip " + long_trip;
        }
        else {
            log "in the log block with mileage " + mileage + " and long_trip " + long_trip;
        }
    }

    rule collect_trips {
        select when explicit trip_processed
        pre {
            mileage = event:attr("mileage").klog("Collect Trips Mileage: ");
            timestamp = time:now();
            obj = {
                "mileage":mileage,
                "timestamp":timestamp
            };
            processed_trips = ent:processed_trips || [];
            new_processed_trips = processed_trips.append(obj);
        }
        fired {
            set ent:processed_trips new_processed_trips;
            log "********LOG explicit trip_processed ent:processed_trips: " + ent:processed_trips;
        }
    }

    rule collect_long_trips {
        select when explicit found_long_trip
        pre {
            mileage = event:attr("mileage").klog("Collect Long Trips Mileage: ");
            timestamp = time:now();
            obj = {
                "mileage":mileage,
                "timestamp":timestamp
            };
            long_trips = ent:long_trips || [];
            new_long_trips = long_trips.append(obj);
        }
        fired {
            set ent:long_trips new_long_trips;
            log "********LOG explicit found_long_trip ent:long_trips: " + ent:long_trips;
        }
    }

    rule clear_trips {
        select when car trip_reset
        pre {
            init = []
        }
        fired {
            set ent:processed_trips init;
            set ent:long_trips init;
            log "********LOG cleared trips ent:processed_trips: " + ent:processed_trips + " ent:long_trips: " + ent:long_trips;
        }
    }

    rule create_well_known {
        select when wrangler init_events
        pre {
            name = event:attr("name").klog("create_well_known got attr(name): ");
            attr = {}.put(["channel_name"],"Well_Known")
                        .put(["channel_type"],"Multi_Picos")
                        .put(["policy"],"")
                        .put(["name"],name)
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

    rule well_known_created {
        select when wrangler channel_created where channel_name eq "Well_Known" && channel_type eq "Multi_Picos"
        pre {
            parent_results = wranglerOS:parent();
            parent = parent_results{'parent'};
            parent_eci = parent[0].klog("parent eci: ");
            well_known = wranglerOS:channel("Well_Known").klog("well known: ");
            well_known_eci = well_known{"cid"};
            init_attributes = event:attrs();
            attributes = init_attributes.put(["well_known"],well_known_eci)
                            .put(["child_eci"],meta:eci());
        }
        {
            event:send({"cid":parent_eci.klog("parent_eci: ")}, "subscriptions", "child_well_known_created")
                with attrs = attributes.klog("event:send attrs: ");
        }
        always {
            log("parent notified of well known channel");
        }
    }

    rule auto_accept {
      select when wrangler inbound_pending_subscription_added 
      pre {
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
  }

    rule fleet_demands_report {
        select when fleet demand_report
        pre {
            all_trips = trips();
            attributes = {}
                            .put(["correlation_identifier"], event:attr("correlation_identifier"))
                            .put(["trips"], all_trips)
                            .put(["child_eci"], meta:eci())
                            ;
            parent_eci = event:attr("parent_eci");
            the_domain = event:attr("domain");
            the_identifier = event:attr("identifier");
        }
        {
            event:send({"cid":parent_eci}, the_domain, the_identifier)
                with attrs = attributes.klog("attributes: ");
        }
        always {
            log "responded to parent: " + parent_eci;
        }
    }

}
