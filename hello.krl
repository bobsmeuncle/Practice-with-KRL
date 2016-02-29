ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    sharing on
    provides hello
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };

    users = function(){
      users = ent:names;
        users
    };
    name = function(id){
      all_users = users();
        first = all_users{[id,name,first]}.defaultsTo("HAL", "could not find user. ");
        last = all_users{[id,name,last]}.defaultsTo("9000", "could not find user. ");
        name = first + " " + last; 
        name;
    };
  }
  rule hello_world {
    select when echo hello
    pre{
      id = event:attr("id");
      default_name = name(id);
      name = event:attr("name").defaultsTo(default_name,"no name passed.");
    }
    {
      send_directive("say") with
        greeting = "Hello #{name}";
    }
    always {
      log "LOG says Hello " + name ;
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
      set ent:name{id} id;
      set ent:name{[id,"name","first"]} first;
      set ent:name{[id,"name","last"]} last;
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

