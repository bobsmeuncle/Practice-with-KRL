ruleset a1299x176 {
    meta {
        name "annotate example"
        author "adam "
        logging off
    }   
     rule clear_name{
        select when pageview re#\?clear=1#
        pre{}
        always {
            clear ent:first;
            clear ent:last;
            last;
        }
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
		
        if(not ent:first) then{// Display notification that will not fade.
          append("#main",a_form);
          watch("#my_form","submit");
        }
        fired {
        	last;
        }
    }
    rule respond_submit {
        select when web submit "#my_form"
        pre{
            first = event:attr("first");
            last = event:attr("last");
        }
        append("#main", "<p> Hello #{username} </p>");
        fired {
            set ent:first first;
            set ent:last last;
        }
    }
    rule replace_with_name {
        select when web pageview ".*"
        pre {
            username = ent:first +" "+ ent:last;
        }
        replace_inner("#main", "<p> Hello #{username} </p>");
    }

  
}