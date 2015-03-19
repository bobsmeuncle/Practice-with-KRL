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
		select when pageview ".*" 
		{
			notify("fired?" , "yes");
		}
	}

	rule inbound_sms {
		select when twilio inbound_sms 
		pre{
			post = event:attr("body");
			post_time = time:strftime(xTime, "%T");
			ent:my_map = { post_time : post};
		}
			
		fired{
			set app:sms_articles ent:my_map;
		}
	}
//	rule retrieve_data {
//		select when explicit need_blog_data  
//
//		fired{
//			raise explicit event 'blog_data_ready'
//			attributes app:sms_articles
//			for b506607x12;
//		}
//	}
}