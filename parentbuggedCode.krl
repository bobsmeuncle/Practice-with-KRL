ruleset manage_fleet {
    meta {
        name "Manage Fleet"
        description <<
Pico for managing a fleet.
        >>
        author "Colby Clark"
        use module b507199x5 alias wranglerOS

        logging on
        sharing on
        provides vehicles, children, known_vehicle, get_trips, get_done_reports, get_running_reports, get_target_ecis, get_event_ecis
    }

    global {
        vehicles = function()
        {
            results = wranglerOS:subscriptions();
            subscriptions = results{"subscriptions"};
            subscriptions
        }

        children = function()
        {
            results = wranglerOS:children();
            children = results{"children"};
            children
        }

        known_vehicle = function(vin)
        {
            known_vehicles = ent:known_vehicles || [];
            known = known_vehicles.any( function(vehicle) {
                    vehicle{"vin"} eq vin
                    })
            known
        }

        get_trips = function()
        {
            target_ecis = get_target_ecis();

            reports = target_ecis.map(function(eci) {
                wranglerOS:skyQuery(eci,"b507706x8.prod","trips","");
            });

            filtered_reports = reports.filter(function(obj) {
                obj{"error"} eq ""
            });

            final_report = {}
                            .put(["vehicles"],target_ecis.length())
                            .put(["responding"],filtered_reports.length())
                            .put(["trips"],filtered_reports)
                            ;
            final_report
        }

        get_target_ecis = function()
        {
            reports = [];
            subs = vehicles();
            subscriptions = subs{"subscribed"};
            stripped_subs = subscriptions.map(function(subscription){
                vals = subscription.values();
                vals.head()
            });

            filtered_subs = stripped_subs.filter(function(obj) {
                obj{"status"} eq "subscribed" && obj{"relationship"} eq "fleet" && obj{"name_space"} eq "Multiple_Picos"
            });

            target_ecis = filtered_subs.map(function(obj) {
                obj{"target_eci"}
            });

            target_ecis
        }

        get_event_ecis = function()
        {
            reports = [];
            subs = vehicles();
            subscriptions = subs{"subscribed"};
            stripped_subs = subscriptions.map(function(subscription){
                vals = subscription.values();
                vals.head()
            });

            filtered_subs = stripped_subs.filter(function(obj) {
                obj{"status"} eq "subscribed" && obj{"relationship"} eq "fleet" && obj{"name_space"} eq "Multiple_Picos"
            });

            event_ecis = filtered_subs.map(function(obj) {
                obj{"event_eci"}
            });

            event_ecis
        }

        get_done_reports = function()
        {
            ent:done_reports || {}
        }

        get_running_reports = function()
        {
            ent:running_reports || {}
        }
    }

    rule create_vehicle {
        select when car new_vehicle

        pre {
          vehicle_attrs = event:attrs();
          already_registered = known_vehicle(vehicle_attrs{"vin"});          
        }
        
        if( not(already_registered) ) then {
          send_directive("vehicle_creation_ok")
        }

        fired {
          raise explicit event "vehicle_creation_ok" attributes vehicle_attrs
        } else {
          log "already registered vin: " + vehicle_attrs{"vin"};
        }
    }

    rule create_vehicle_check {
        select when explicit vehicle_creation_ok
            pre {
                name = event:attr("name") || "Vehicle-"+math:random(99999);
                attributes = {}
                                .put(["Prototype_rids"],"b507706x9.dev")
                                .put(["name"],name)
                                ;
            }
            {
                event:send({"cid":meta:eci()}, "wrangler", "child_creation")
                    with attrs = attributes.klog("attributes: ");
            }
            always {
                log("create child for " + meta:eci());
            }
            
    }

    rule request_subscription {
        select when subscriptions child_well_known_created

        pre {
            child_well_known_eci = event:attr("well_known").klog("parent received child_well_known_eci: ");
            name = event:attr("name") || "Fleet to " + child_well_known_eci;
            attributes = {}.put(["name"], name)
                            .put(["name_space"], "Multiple_Picos")
                            .put(["my_role"], "fleet")
                            .put(["your_role"], "vehicle")
                            .put(["target_eci"], child_well_known_eci)
                            .put(["channel_type"], "Creating_Multiple_Picos")
                            .put(["attrs"], "success")
                            ;
        }
        {
            event:send({"cid":meta:eci()}, "wrangler", "subscription")
                with attrs = attributes.klog("attributes for subscription: ");
        }
        always {
            log("send child well known " + child_well_known_eci + "subscription for parent " + meta:eci());
        }
    }

    rule delete_vehicle {
        select when car unneeded_vehicle
            pre {
                eci = event:attr("eci").klog("delete this eci: ");

                attributes = {}
                            .put(["deletionTarget"], eci)
                            ;
            }

            if (eci neq '') then {
                event:send({"cid":meta:eci()}, "wrangler", "child_deletion")
                    with attrs = attributes;
            }

            always {
                log "can't delete an empty eci: " + eci;
            }
    }

    rule scatter_generate_report {
        select when fleet scatter_report
        pre {
            correlation_identifier = event:attr("correlation_identifier") || "Report-"+math:random(99999);
            target_ecis = get_event_ecis();
            attrs = {}
                        .put(["correlation_identifier"], correlation_identifier)
                        //.put(["target_ecis"], target_ecis)
                        .klog("here are the attrs: ")
                        ;
        }
        fired {
            set ent:event_ecis target_ecis;
            raise explicit event 'scatter_report_execute'
                attributes attrs;
            log "successfully raised the explicit event 'scatter_report_execute'";
        }
    }

    rule scatter_report_execute {
        select when explicit scatter_report_execute
        foreach ent:event_ecis setting (eci)
        pre {
            correlation_identifier = event:attr("correlation_identifier");
            tmp = ent:running_reports || {};
            this_running_report = tmp{[correlation_identifier]} || [];
            temp = this_running_report.append(eci);
            running_reports = tmp.put([correlation_identifier], temp);
            attributes = {}
                            .put(["correlation_identifier"],event:attr("correlation_identifier"))
                            .put(["parent_eci"], meta:eci())
                            .put(["domain"], "vehicle")
                            .put(["identifier"], "return_and_report")
                            .klog("scatter_report_execute build up attribs: ")
                            ;
        }
        {
            event:send({"cid":eci}, "fleet", "demand_report")
                with attrs = attributes.klog("attributes: ");
        }
        always {
            set ent:running_reports running_reports;
            log "scatter_report_execute sent event to " + eci;
        }
    }

    rule scatter_gather_report {
        select when vehicle return_and_report
        pre {
            result_sets = ent:done_reports || {};
            correlation_identifier = event:attr("correlation_identifier");
            tmp = done_reports{[correlation_identifier]};
            finished_trips = tmp.append(event:attr("trips"));
            updated_result_sets = result_sets.put([correlation_identifier], finished_trips);

            tmp = ent:running_reports || {};
            this_running_report = tmp{[correlation_identifier]} || [];
            temp = this_running_report.filter(function(eci) {
                eci neq event:attr("child_eci")    
            });
            running_reports = tmp.put([correlation_identifier], temp);
            
        }

        if (running_reports{[correlation_identifier]}.length() == updated_result_sets{[correlation_identifier]}.length()) then {
            send_directive("alldone");
        }
        fired {
            raise explicit event 'all_done_with_scattered_reports'
                attributes event:attrs();

            set ent:running_reports running_reports;
            set ent:done_reports updated_result_sets;
            log ("we are done!");
        } else {
            set ent:running_reports running_reports;
            set ent:done_reports updated_result_sets;
            log("we are not done yet");
        }
    }

    rule all_done_with_scattered_reports {
        select when explicit all_done_with_scattered_reports
        pre {
            attributes = event:attrs().klog("all done attrs: ");
        }
        fired {
            log "now we are free!";
        }
    }
}

