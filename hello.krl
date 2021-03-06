ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart version:2
>>
    author "Phil Windley version:4"
    logging on
    sharing on
    provides hello, users , name , user 
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };

    users = function(){
      users = ent:name;
        users;
    };
    name = function(id){
      all_users = users();
        first = all_users{[id, "name", "first"]}.defaultsTo("HAL", "could not find user. ");
        last = all_users{[id, "name" , "last"]}.defaultsTo("9000", "could not find user. ");
        name = first + " " + last; 
        name;
    };

    heyYo = function(full_name){
      all_users = users();
      filtered_users = all_users.filter( function(user_id, val){
        constructed_name = all_users{[user_id,"name","first"]} + " " + all_users{[user_id,"name","last"]};
        (constructed_name eq full_name);
        });
      user_id = filtered_users.keys().head().defaultsTo("_0","no user found").klog("user_id: "); 
      user = all_users{user_id}.klog("user : ");
      user_hash = {}.put([user_id],user).klog("user_hash: ");
      user_hash;
    };

  }
   rule new_user {
    select when explicit new_user
    pre{
      id = event:attr("id").klog("our pass in Id: ");
      first = event:attr("first").klog("our passed in first: ");
      last = event:attr("last").klog("our passed in last: "); 
      new_user = {
          "name":{
            "first":first,
              "last":last
              },
          "visits": 1
          };
      }{
      send_directive("new_user") with
      passed_id = id and
      passed_first = first and
      passed_last = last;
    }
    always{
      set ent:name{[id]} new_user;
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
          log "auto accepted subcription." ;
    }
  }



  rule hello_world {
    select when echo hello
    pre{
      name = event:attr("name").defaultsTo("HAL 9000","no name passed.");
      full_name = name.split(re/\s/);
      first_name = full_name[0].klog("first : ");
      last_name = full_name[1].klog("last : "); // note we don't check name format its assumed.
      check = user(name).klog("user result: ");
      get_id = function(user) {
        user_hash = user.keys();
        id = user_hash[0];
        id;
      };
      id_check = get_id(check).klog("id: ");
      user_id = (id_check neq "_0") => id_check| math:random(999); // note we do not check for duplicates 
      new_user = (id_check eq "_0") => 
              {
                "id"    : user_id, 
                "first" : first_name,
                "last"  : last_name
              } | {};
    }
    if(id_check eq "_0" ) then {
        send_directive("say") with
          something = "Hello #{name}";
    }
    fired {
        raise explicit event 'new_user' // common bug to not put in ''.
          attributes new_user;        
          log "LOG says Hello " + name ;
    }
    else {
          log "LOG says Hello " + name ;
          set ent:name{[user_id,"visits"]} ent:name{[user_id,"visits"]} + 1;
    }
  }



  /*
  rule hello_world {
    select when echo hello
    pre{
      id = event:attr("id");
      default_name = name(id);
    }
    {
      send_directive("say") with
        greeting = "Hello #{default_name}";
    }
    always {
      log "LOG says Hello " + default_name ;
    }
  }
  rule store_name {
    select when hello name
    pre{
      id = event:attr("id").klog("our pass in Id: ");
      first = event:attr("first").klog("our passed in first: ");
      last = event:attr("last").klog("our passed in last: ");
      init = {"_0":{
                    "name":{
                            "first":"GLaDOS",
                            "last":""}}
              }
    }
    {
      send_directive("store_name") with
      passed_id = id and
      passed_first = first and
      passed_last = last;
    }
    always{
      set ent:name init if not ent:name{["_0"]}; // initialize if not created. table in data base must exist for sets of hash path to work.
      set ent:name{[id,"name","first"]}  first;
      set ent:name{[id, "name", "last"]}  last; 
    }
  }
/* rule store_name {
  select when hello name
  pre{
   passed_name = event:attr("name").klog("our passed in Name: ");
    }{
      send_directive("store_name") with
      name = passed_name;
    }
    always{
      set ent:name passed_name;
    }
  }
  rule store_name {
    select when hello name
    pre{
      id = event:attr("id").klog("our pass in Id: ");
      first = event:attr("first").klog("our passed in first: ");
      last = event:attr("last").klog("our passed in last: ");
      }{
      send_directive("store_name") with
      passed_id = id and
      passed_first = first and
      passed_last = last;
    }
    always{
      set ent:names{id} id;
      set ent:names{[id,name,first]} first;
      set ent:names{[id,name,last]} last;
    }
  }*/
 }

