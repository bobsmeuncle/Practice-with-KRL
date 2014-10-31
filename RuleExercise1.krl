
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
        
        pre{}
        {// Display notification that will not fade.
          notify("Hello World", "I think!") with sticky = true;
          notify("therefore", "I am!") with sticky = true;
        }
    }
    rule second_rule {
        select when pageview ".*" setting ()
        pre {
          pagequery = page:url ("query");
          name = name.extract(re#name=(\w*),#);
          name = name[0];
          greating = pagequery.length() == 0 => "Hello Monkey" | "Hello "  + name;
        }
        {//Display notification that will not fade.
          notify("Greating",greating) with sticky = true;
        }
    }
    rule third_rule {
        select when pageview ".*" setting ()
        
        pre{

        }
          if (ent:pageCount < 6 ) then
            notify("fired count", ent:pageCount) with sticky = true;
            
        fired{
          ent:pageCount += 1 from 1; // from 1 ???
        } else{
          clear ent:pageCount;
        }
    }
        rule fourth_rule {
        select when pageview ".*" setting ()
        
        pre{
          pagequery = page:url ("query");
        }
            if (pagequery.match(re/clear/)) then
              notify("parameter", "clear") with sticky = true; 
          fired{
            clear ent:pageCount;
          }

    }
}