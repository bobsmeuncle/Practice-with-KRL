

ruleset song_store {
	meta {  
		name "song_store"
		description <<
		song store rule sets.
		>>
		author "adam burdett"
		logging on
		provides songs, hymns, secular_music
		sharing on
	}
	global{

		songs = function(){
			songs = ent:songs;
			songs;
		};
		hymns = function(){
			hymns = ent:hymns;
			hymns;
		};
		secular_music = function(){

		sec_music=ent:songs.values().difference(ent:hymns.values());

      	sec_music;

		};

	}

	rule collect_songs{
		select when explicit sung input "(.*)" setting(song) and msg_type "song"
		pre{
			s = { time:now() : event:attr("song") };
			songs = s.put(ent:songs);
		}
		{
			noop();
		}
		always{
			set ent:songs songs;
		}

	}

	rule collect_words{ // I think of rulesets as complex if statments with in a large loop.
		select when explicit word
		pre{  // i use my pre block to build my objects and to do any calculations i need.
			word = { time:now() : event:attr("word") }; // an object like a dictionary. this creates a time key to worde value object
			words = word.put(ent:words);
			bool = ent:bool;
		}
		 // this is where i check results from my pre block calculations and handle locgic flow of other events to be raised
		if (bool > 0 ) then {
        	send_directive("directive_of_something") 
	        	with adam = cool;
      		}
		// postlude usally is conditioned on if the condition above evaluated true or false.
		fired{  // the only way you can mutate persistant variables is in this postlude block, no where else.
			set ent:words words; // only a few key words will mutate a persistant variable, i dont know of any functions.
		}	else {
        	raise explicit event adam_rocks;  
        }

	}
	rule collect_hymns{
		select when explicit found_hymn
		pre{
			h = {
				time:now() :event:attr("hymn")
			};
			hymns = h.put(ent:hymns);
		}
		{
			noop();
		}
		always{
			set ent:hymns hymns;
		}

	}

	rule clear_songs{
		select when song empty 
		always{
			clear ent:hymns;
			clear ent:songs;
		}

	}
}