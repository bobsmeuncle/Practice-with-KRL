
ruleset a1299x176 {
    meta {
        name "notify example"
        author "adam "
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule first_rule {
        select when pageview ".*" setting ()
        // Display notification that will not fade.
        pre{}
        {
          notify("Hello World", "I think!") with sticky = true;
          notify("therefore", "I am!") with sticky = true;
        }
    }
    rule second_rule {
        select when pageview ".*" setting ()
        pre {
          pagequery = page:url ("query");
          name = pagequery.extract(re/name=([^&]*)/)[0];
          greating = pagequery.length() == 0 => "Hello Monkey" | "Hello "  + name;
           // + pagequery.extract(re/name=([^&]*)/) [0];
          //+pagequery.split(re/,/)[0].split(re/=/)[1];
        }
        {//Display notification that will not fade.
          notify("Greating",greating) with sticky = true;
        }
    }
}