//Name:Foursquare Checkins
//ID:FC64E88C-6F51-11E4-8766-859FE71C24E1
///http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/foursquare/checkin

ruleset FourSquareCheckin {
	meta {  
		name "FourSquare CheckIn"
		description <<
		Checkin In With Foursquare
		>>
		author "adam burdett"
		logging off

		use module a169x701 alias CloudRain
		use module a41x186  alias SquareTag
	}

	global {

	}

	rule process_fs_checkin{
		select when foursquare checkin

		pre{
			data = event:attr("checkin").decode();
			venue = data.pick("$..venue");
			city = data.pick("$..city");
			shout = data.pick("$..shout");
			date = data.pick("$..createdAt");
			location = venue.pick("$..location");
			lat = location.pick("$..lat");
			long = location.pick("$..lng");
		}
		{
			send_directive("A FS Checkin") with checkin = "Im Here";
		}
		fired{
			set ent:venue venue;
			set ent:city city;
			set ent:shout shout;
			set ent:createdAt createdAt;
			set ent:data event:attr("checkin").as("str");
			set ent:lat lat;
			set ent:lng long;
			set ent:fired venue;

			raise pds event new_location_data for b505289x4
			with key = "fs_checkin"
			//	and value = "Is It Working";
			and value = {"venue" : venue.pick("$.name"), "city" : city, "shout" : shout, "date" : createdAt, "lat" : lat , "long" : long};
		}
	}

	rule display_checkin{
		select when cloudAppSelected
		pre {
			venue = ent:venue.pick("$.name").as("str");
			city = ent:city.as("str");
			shout = ent:shout.as("str");
			createdAt = ent:createdAt.as("str");
			data = ent:working.as("str");
			html = <<
			<h1>Checkin Data:</h1>
			<b>I Was At: </b> #{venue}<br/>
			<b>In: </b> #{city}<br/>
			<b>Yelling: </b> #{shout}<br/>
			<b>On: </b> #{createdAt}<br/>
			<b>Works: </b> #{data}<br/>
			<b> End of Data. </b>
			<br/>
			>>;
		}
		CloudRain:createLoadPanel("Foursquare", {}, html);

	}

	rule displayMEWOrking{
		select when pageview ".*" {
			notify("Working?" , ent:city.as("str"));
			notify("fired?" , ent:fired);
		}

	}
}