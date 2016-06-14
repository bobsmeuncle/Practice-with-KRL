#learned from http://www.allaboutcircuits.com/projects/raspberry-pi-project-control-a-dc-fan/
#import RPi.GPIO as GPIO
#import smbus
import time
import requests
import random

#0 = /dev/i2c-0
#1 = /dev/i2c-1
I2C_BUS = 0
#bus = smbus.SMBus(I2C_BUS)
    
#7 bit address (will be left shifted to add the read write bit)
#DEVICE_ADDRESS = 0x48      

#GPIO.setwarnings(False)
#GPIO.setmode(GPIO.BCM)
FAN_PIN = 23
#GPIO.setup(FAN_PIN, GPIO.OUT)

KRE_BOX_FAN = "https://kibdev.kobj.net/sky/cloud/b507706x14.prod/box_fan_state"
data = {'_eci': '3EFEEEEE-AF53-11E5-81D4-E8B8D34451B4','_eid':random.randint(0,9999999)}

while True:
	time.sleep(2)
	#Read the fan status 
	data['_eid'] +=1

	print(data)
	print(KRE_BOX_FAN)
	IO = requests.post(KRE_BOX_FAN,data)
	
	print IO.content

	#control the fan based on the temp
	if(IO.content == "1"):
		#GPIO.output(FAN_PIN, True)
		print("true")
	if(IO.content == "2"):
		#GPIO.output(FAN_PIN, False)
		print("false")