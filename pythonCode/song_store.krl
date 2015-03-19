

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
		select when explicit sung
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