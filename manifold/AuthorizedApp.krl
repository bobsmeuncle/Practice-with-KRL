ruleset AuthorizedApp {
	meta {
		name "app authorization"
		description << manage apps authorization >>
		author "Tedrub moda"
		logging on
		shares getAuthorizedApps, getAppTokenSecrets
	}

	global {

		getAuthorizedApps = function(){
			apps()
		}
		getAuthorizedApp = function(appToken){
			apps(appToken)
		}
		getAppTokenSecrets = function(){
			{
		        "status" : (true),
		        "appsTokenSecrets" : ent:AppTokenSecrets
		      }
		}
		    apps = function(app_eci) { 
		      eci = meta:eci;
		      apps = ent:AuthorizedApps;
		      // check for parameter and return acordingly 
		      results = (app_eci.isnull()) => 
		          apps |
		          apps{app_eci};
		      {
		        "status" : (true),
		        "apps" : apps
		      }
		    } 

		    list_bootstrap = function(appECI){
		    	apps(appECI){"bootstrap"}
		    }

		    list_callback = function(appECI){
		    	apps(appECI){"callback"}
		    }

	}

    //-------------------OAuthRegistry---------------

	      //-------------------- Apps --------------------
	      rule authorizeApp {
	      	select when wrangler authorize_app_requested
	      	pre {
	      		info_page = event:attr("info_page").defaultsTo("", "missing event attr info_page")
	      		bootstrap_rids = event:attr("bootstrap_rids").defaultsTo("", "missing event attr bootstrap_rids")
	      		app_name = event:attr("app_name").defaultsTo("error", "missing event attr app_name")
	      		app_description = event:attr("app_description").defaultsTo("", "missing event attr app_description")
	      		app_image_url = event:attr("app_image_url").defaultsTo("", "missing event attr app_image_url")
	      		app_callback_url_attr = event:attr("app_callback_url").defaultsTo("error", "missing event attr app_callback_url")
	      		app_callback_url = app_callback_url_attr.split(re#;#).defaultsTo("error", "split callback failure")
	      		app_declined_url = event:attr("app_declined_url").defaultsTo("", "missing event attr app_declined_url")
	      		bootstrap = bootstrap_rids.split(re#;#).defaultsTo("", "split bootstraps failure")
	      		//pico_id = meta:eci
	      		appToken = null.uuid()
                appSecret = null.uuid() // comparible to a passward, but for an app, old system had it, but did not use it...
             	app = { 
              		"name" : app_name ,
  					"description" : app_description ,
  					"icon" : app_image_url ,
  					"info_url" : info_page ,
  					"declined_url" : app_declined_url ,
  					"callback" : app_callback_url , 
  					"bootstrap" : bootstrap,
  					"token" : appToken
                }
                updatedAuthApps = getAuthorizedApps().put([appToken],app)
                updatedAppTokenSecrets = getAppTokenSecrets().put([appToken],appSecret)
	      	}
	      	if ( app_name != "error" && app_callback_url != "error" ) 
	      	then noop()
	      	fired {
                //app:AuthorizedApps := updatedAuthApps;
                ent:AuthorizedApps := updatedAuthApps;
                //app:AppTokenSecrets := updatedAppTokenSecrets;
                ent:AppTokenSecrets := updatedAppTokenSecrets;
	      		log "success authenticated app #{app_name}"
	      	}
	      	else {
	      		log "failure"
	      	}
	      }

	      rule removeApp {
	      	select when wrangler remove_app_requested
	      	pre {
	      		identifier = event:attr("app_id").defaultsTo(event:attr("token"),"missing token").klog(">>>>>> token >>>>>>>")
	      	}
	      	if (identifier != "") then 
	      		noop() //pci:delete_app(identifier);
	      	
	      	fired {
	      		ent:AuthorizedApps := ent:AuthorizedApps.delete([identifier]);
	      		log "success deauthenticated app with token #{identifier}"
	      	}
	      	else {
	      		log "failure"
	      	}
	      }

	      rule updateApp {
	      	select when wrangler update_app_requested
	      	pre {
	      		identifier = event:attr("app_id").defaultsTo(event:attr("token"),"missing token").klog(">>>>>> token >>>>>>>")
	      		old_app = getAuthorizedApp(identifier).defaultsTo("error", "oldApp not found").klog(">>>>>> old_app >>>>>>>")
				
				info_page = event:attr("info_page").defaultsTo("", "missing event attr info_page")
	      		bootstrap_rids = event:attr("bootstrap_rids").defaultsTo("", "missing event attr bootstrap_rids")
	      		app_name = event:attr("app_name").defaultsTo("error", "missing event attr app_name")
	      		app_description = event:attr("app_description").defaultsTo("", "missing event attr app_description")
	      		app_image_url = event:attr("app_image_url").defaultsTo("", "missing event attr app_image_url")
	      		app_callback_url_attr = event:attr("app_callback_url").defaultsTo("error", "missing event attr app_callback_url")
	      		app_callback_url = app_callback_url_attr.split(re#;#).defaultsTo("error", "split callback failure")
	      		app_declined_url = event:attr("app_declined_url").defaultsTo("", "missing event attr app_declined_url")
	      		bootstrap = bootstrap_rids.split(re#;#).defaultsTo("", "split bootstraps failure")
	      		//pico_id = meta:eci
             	app = { 
              		"name" : app_name ,
  					"description" : app_description ,
  					"icon" : app_image_url ,
  					"info_url" : info_page ,
  					"declined_url" : app_declined_url ,
  					"callback" : app_callback_url , 
  					"bootstrap" : bootstrap,
  					"token" : appToken
                }
                updatedAuthApps = getAuthorizedApps().put([identifier],app)
	      	}
	      	if ( 
	      		old_app != "error" &&
	      		app_name != "error" &&
	      		app_callback_url != "error" 
	      		) then noop()
	      	fired {
	      		ent:AuthorizedApps := updatedAuthApps;
	      		log "success update app with #{app_data}"
	      	}
	      	else {
	      		log "failure"
	      	}
	      }

	      rule authorize {
	      	select when wrangler authorize api_key re#84# response_type re#code#//speacial key
	      	pre {
	      		response_type = event:attr("response_type")
	      		redirect_uri = event:attr("redirect_uri")
        		client_id = event:attr("client_id")
        		state = event:attr("state")
        		//code = 
	      	}
	      	if (redirect_uri == list_callback(client_id) ) then 
	      		noop()
	      		//event:send(state,code)
	      	
	      	fired {
	      		//ent:code := ent:code.put()
	      	}
	      	else {
	      	}
	      }
	      
	      rule access_token {
	      	select when wrangler access_token api_key re#84# grant_type re#authorization_code#
	      	pre {
	            grant_type = event:attr("grant_type")
	            redirect_uri = event:attr("redirect_uri")
	            client_id = event:attr("client_id")
	            code = event:attr("code")
	      	}
	      	if (redirect_uri == list_callback(client_id) //&& code == ent:code 
	      		) then 
	      		//event:send()
	      		noop()
	      	fired {
	      	}
	      	else {
	      	}
	      }
}