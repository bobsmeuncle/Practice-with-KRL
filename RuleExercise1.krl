
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
        notify("Hello World", "I think!") with sticky = true;
        notify("therefore", "I am!") with sticky = true;
    }
}