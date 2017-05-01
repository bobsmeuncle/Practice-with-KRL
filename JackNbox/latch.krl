ruleset latch {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ {"domain": "jackNbox","type":"open_door"}] }
  }
  rule OpenDoor {
    select when jackNbox open_door
     pre{
        open = 1200
        close = 950
    }
     gpio:servoWrite(10,open)
     time:sleep(500)
     gpio:servoWrite(10,close)
  }
  
}
/* time.js
module.exports = {
    def: {
        now: function*(ctx, args){
            return (new Date()).toISOString();
        },
        sleep:function*(ctx,args) {
        		var start = new Date().getTime();
        		for (var i =0; i< 1e7; i++) {
        			if ((new Date().getTime() - start) > args[0]) {
	    	    		break;
       	 		}
    			}
    		}
    }
};
*/
