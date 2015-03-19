ruleset sms_blog {
	meta {
		name "sms_blog"
		description <<
		sms_blog Exercise, sms_blog ruleset.
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
	rule init_blog {
		select when pageview ".*"
		pre{
			a_div= <<
			<div id="blogbody">
				<ul id= "unorderlist">
					
				</ul>
			</div>
			>>;
		}
		{
			append("#DOM", a_div);
		}
		fired{
			raise explicit event 'container_ready';
			raise explicit event 'need_blog_data' for b506607x13;
		}
	}
	rule show_articles {
		select when explicit container_ready 
			and explicit blog_data_ready  
		foreach event:attr("sms_articles") setting (post_time,post)
	
		{
			append("#unorderlist","<li>post time: #{post_time} post: #{post}</li>");
		}
	}
}