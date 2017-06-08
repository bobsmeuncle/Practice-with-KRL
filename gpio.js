var Gpio = require('pigpio').Gpio;
var pins = {};
var mkKRLfn = require("../mkKRLfn");

module.exports = function(core){	

return{
	def:{
   	 digitalRead: mkKRLfn(["pin"],function (args, ctx , callback) {
		      pin_str = args.pin.toString();	 
				if (pins[pin_str]) {
  					return callback( null , pins[pin_str].digitalRead());
				}
				   callback(void 0 , null);
   	 }),
   	 pinIntialized: mkKRLfn(["pin"],function (args, ctx , callback) {
			  callback(null, !!pins[args.pin.toString()]);
   	 })
 	},
 	actions:{
 	servoWrite: mkKRLfn(["pin","value"] , function(args, ctx , callback){  
    			pin_str = args.pin.toString();  	 
				if (!pins[pin_str]) {
  					pins[pin_str] = new Gpio(args.pin, {mode: Gpio.OUTPUT});
				}
				callback(null,pins[pin_str].servoWrite(args.value));
   	 }),
   	 digitalWrite: mkKRLfn(["pin","value"],function (args, ctx , callback) {
		      pin_str = args.pin.toString();  	
				if (!pins[pin_str]) {
  					pins[pin_str] = new Gpio(args.pin, {mode: Gpio.OUTPUT});
				}
				callback(null,pins[pin_str].digitalWrite(args.value));
   	 })
 	}
 }
};
/*
        type: mkKRLfn([ ], function(args, ctx, callback){
            callback(null, _.get(ctx, ["event", "type"], null));
        }),
        domain: mkKRLfn([ ], function(args, ctx, callback){
            callback(null, _.get(ctx, ["event", "domain"], null));
        }),

*/
