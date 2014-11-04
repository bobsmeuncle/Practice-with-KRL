ruleset a1299x176 {
    meta {
        name "annotate example"
        author "adam "
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule show_form
     {
        select when pageview ".*" setting ()

        pre{}
        emit << 
    		console.log('injected javascript');
		>>;
        {// Display notification that will not fade.
          notify("Hello World", "I think!") with sticky = true;
          notify("therefore", "I am!") with sticky = true;
        }
    }
  
}