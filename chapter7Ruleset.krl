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
    		console.log('hello adam, injected javascript');
		>>;
		//replace_inner("#main"," i am replacing content and not inserting!")
		append("#main","<p>tis a good day!</p>")
        {// Display notification that will not fade.
          notify("Hello World", "I think!") with sticky = true;
          notify("therefore", "I am!") with sticky = true;
        }
    }
  
}