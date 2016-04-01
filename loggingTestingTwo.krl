ruleset subscriptions {
  meta {
    name "logging development"
    description <<
    test event logging bettween parent and child picos.
>>
    author "adam burdett"
    use module  b507199x5 alias wrangler_api
    logging on
    sharing on
    //provides hello 
 
  }
  global {

  }

  rule childToParent { 
    select when parent hello_child 
    pre {
      attributes = {}.put(["name"],"child")
                      .put(["attrs"],"success")
                      ;
    }
    {
      event:send({"cid":"D7609700-B0C0-11E5-8615-11C8E71C24E1".klog("parent: ")}, "child", "hello_parent")  
        with attrs = attributes.klog("attributes for event Send: ");
    }
    always{ 
      log("hello to parent"); 
    }
  }

  rule childToParentAgain { 
    select when parent hello_child_again 
    pre {
      attributes = {}.put(["name"],"child_again")
                      .put(["attrs"],"success_again")
                      ;
    }
    {
      event:send({"cid":"D7609700-B0C0-11E5-8615-11C8E71C24E1".klog("parent: ")}, "child", "hello_parent_again")  
        with attrs = attributes.klog("attributes for event Send: ");
    }
    always{ 
      log("hello to parent"); 
    }
  }

 }

