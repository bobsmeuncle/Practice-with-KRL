

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
			songs = ent:songs.map(function(pair){
				value =	pair.values();
				value[0];
				});
			hymns = ent:hymns.map(function(pair){
				value =	pair.values();
				value[0];
				});
			result = songs.difference(hymns);
			result;
		};
	}

	rule collect_songs{
		select when explicit sung
		pre{
			time = time:now();
			song = event:attr("song").klog("<<song>> ");
			s = {
				time : song
			};
		}
		always{
			songs = ent:songs;
			songs.append(s);
			set ent:songs songs;
		}

	}
	rule collect_hymns{
		select when explicit found_hymn
		pre{
			time = time:now();
			hymn = event:attr("hymn").klog("<<hymn>> ");
			h = {
				time: hymn
			};
		}
		always{
			hymns = ent:hymns;
			hymns.append(h);
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