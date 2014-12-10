ruleset sms_blog_data {
	meta {
		name "Blog_Data"
		description <<
		Twilio sms blog Exercise, sms_blog_data ruleset.
		>>
		author "adam burdett"
		logging on
	}

	global {
		
	}
	rule displayMEWOrking{
		select when pageview ".*" {
			notify("fired?" , "yes");
		}
	}
	rule inbound_sms {
		select when twilio inbound_sms 
		{
			ent:my_map = { time:strftime(xTime, "%T") : event:attr("body") };
		}
		fired{
			app:sms_articles;
		}
	}
	rule retrieve_data {
		select when explicit need_blog_data  
		{

		}
		fired{
			raise explicit event 'blog_data_ready'
				attributes app:sms_articles
				for ;

		}


		}
	}
}