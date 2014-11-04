ruleset a1299x176 {
    meta {
        name "chapter 7 example"
        author "adam "
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule clear_name{
        select when pageview re#\?reset#
        always {
            clear ent:username;
            last
        }
    }
    rule initialize {
        select when pageview url re#.*#
        pre{
            blank_div = << <div id="my_div"></div> >>;
        }
        notify("Hello Example", blank_div)
        with sticky = true;
    }
    rule send_form{
        select when pageview url #.*#
        pre{
            a_form = <<
            <form id="my_form" onsubmit="return false">
            First name: <input type="text" name="first"/> <br>
            Last name: <input type="text" name="last"/> <br>
            <input type="submit" vallue="submit"/>
            </form>
            >>;

        }
        if(not ent:username) then{
            append("#my_div", a_form);
            watch("#my_form", "submit");
        }
        fired{
            last;
        }
    }
    //respond_submit is dead code now
    rule respond_submit {
        select when web submit "#my_form"
        pre{
            username = event:attr("first")+" "+event:attr("last");
        }
        replace_inner("#my_div", "Hello #{username}");
        fired {
            set ent:username username;
        }
    }
    rule replace_with_name {
        select when web pageview ".*"
//            or web submit "#my_form"
        pre {
            username = current ent:username;
        }
        replace_inner("#my_div", "Hello #{username}");
    }
}