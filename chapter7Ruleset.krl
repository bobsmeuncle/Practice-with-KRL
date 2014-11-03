ruleset a1299x176 {
    meta {
        name "notify example"
        author "adam "
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule show_form {
        select when pageview ".*" setting ()
        
        pre{}
        {// Display notification that will not fade.
          notify("Hello World", "I think!") with sticky = true;
          notify("therefore", "I am!") with sticky = true;
        }
    }
  
}