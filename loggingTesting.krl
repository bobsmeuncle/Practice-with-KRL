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

  rule parentToChild { 
    select when start hello_child 
    pre {
      attributes = {}.put(["name"],"parent")
                      .put(["attrs"],"success")
                      ;
    }
    {
      event:send({"cid":"AA78B9D8-F36F-11E5-9E84-4FE9E71C24E1".klog("parent: ")}, "parent", "hello_child")  
        with attrs = attributes.klog("attributes for event Send: ");
    }
    always{ 
      log("hello to parent"); 
    }
  }

  rule ParentToChildAgain { 
    select when child hello_parent 
    pre {
      attributes = {}.put(["name"],"parent_again")
                      .put(["attrs"],"success_again")
                      ;
    }
    {
      event:send({"cid":"AA78B9D8-F36F-11E5-9E84-4FE9E71C24E1".klog("parent: ")}, "parent", "hello_child_again")  
        with attrs = attributes.klog("attributes for event Send: ");
    }
    always{ 
      log("hello a second time"); 
    }
  }


 }

