ruleset StockChecker {
	meta {
		name "StockChecker"
		description <<
		Twilio Stock Checker Exercise.
		>>
		author "adam burdett"
		logging on
	}

	global {
//		stockmessage = function() {
//               val = http:get("http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,fb&f=l1&e=.csv",
//              {"s" : "%40%5EDJI,fb",
//              "f" : "l1",
//               "e" : ".csv"});
//               fbstock = val.pick("$.content").decode();
//               return = fbstock < 38 => 
//               	"Fail! Facebook's latest stock price of #{fbstock} dollars is still below it's IPO price!" |
//               	"Awesome! Facebook's latest stock price of #{fbstock} dollars is above it's IPO price!";
//               return
//            }
	}
	rule displayMEWOrking{
		select when pageview ".*" {
//			notify("Working?" ,stockmessage()) with sticky = true;
			notify("fired?" , "yes");
		}
	}
//	rule twilioCallstart {
//		select when twilio callstart 
//		pre {
//			fbstock = stockmessage();
//		}
//		{
//			twilio:say(fbstock);
//			twilio:hangup();
//		}
//	}
//	rule twilioSMS {
//		select when twilio sms  
//		pre {
//			fbstock = stockmessage();
//		}
//		{
//			twilio:sms(fbstock);
//		}
//	}
}