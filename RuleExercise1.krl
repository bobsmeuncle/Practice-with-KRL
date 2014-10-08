
ruleset a1299x176 {
    meta {
        name "notify example"
        author "nathan cerny"
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule first_rule {
        select when pageview ".*" setting ()
        // Display notification that will not fade.
        notify("Hello", "This notice 1") with sticky = true;
       // notify("Hello World", "This is notice 2") with sticky = true;
    }
    //Add a second rule that places a third notification box on the page. 
    //This notification box should say "Hello " followed by the value of query string. 
    //If the query string is empty, say "Hello Monkey". You may find the url function in the page library helpful. 
   // rule second_rule {
    //    select when pageview ".*" setting ()
   //     pre {
   //       pagequery = page:url ("query");
   //       greating = pagequery.length() == 0 => "Hello Monkey" | "Hello " + pagequery ;
         // welcome = "hello " + (pagequery) 
        }
        // Display notification that will not fade.
   //     notify(greating) with sticky = true;
   // }
}