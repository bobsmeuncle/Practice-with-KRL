

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
			not_hyms = ent:songs.values()
			.klog("<<songs>> ")
			.difference(ent:hymns.values()
			.klog("<<hymns>> ")
			)
			.klog("<<difference>> ")
			;
			not_hyms;
		};
	}

	rule collect_songs{
		select when explicit sung
		pre{
			time = time:now();
			song = atr("song").klog("<<song>> ");
			songs = {
				"song" : song,
				"time" : time
			};
			c = songs.put(ent:songs);
		}
		always{
			set ent:songs c;
		}

	}
	rule collect_hymns{
		select when explicit found_hymn
		pre{
			time = time:now();
			hymn = atr("hymn").klog("<<hymn>> ");
			hymns = {
				"hymn" : hymn,
				"time" : time
			};
			c = hymns.put(ent:hymns);
		}
		always{
			set ent:hymns c;
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