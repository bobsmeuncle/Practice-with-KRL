ruleset a1299x176 {
    meta {
        name "annotate example"
        author "adam "
        logging off
    }
    rule show_form
     {
        select when pageview ".*" setting ()

        pre{
        a_form = <<
            <form id="my_form" onsubmit="return false">
            First name: <input type="text" name="first"/> <br>
            Last name: <input type="text" name="last"/> <br>
            <input type="submit" vallue="submit"/>
            </form>
            >>;
        }
        emit << 
    		console.log('hello adam, injected javascript');
		>>;
		
        {// Display notification that will not fade.
          append("#main","<p>tis a good day!</p>");
          notify("Hello World", "I think!") with sticky = true;
          notify("therefore", "I am!") with sticky = true;
        }
    }
  
}