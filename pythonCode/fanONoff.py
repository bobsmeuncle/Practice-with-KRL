#learned from http://www.allaboutcircuits.com/projects/raspberry-pi-project-control-a-dc-fan/
import RPi.GPIO as GPIO
import smbus
import time
import requests

#0 = /dev/i2c-0
#1 = /dev/i2c-1
I2C_BUS = 0
bus = smbus.SMBus(I2C_BUS)
    
#7 bit address (will be left shifted to add the read write bit)
DEVICE_ADDRESS = 0x48      
TEMP_THRESHOLD = 78
TEMP_HYST = 2

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
FAN_PIN = 23
GPIO.setup(FAN_PIN, GPIO.OUT)

KRE_BOX_FAN = ""

while True:
	time.sleep(2)
	#Read the fan status 
	IO = requests.get(KRE_BOX_FAN)
	
	print IO

	#control the fan based on the temp
	if(IO):
		GPIO.output(FAN_PIN, True)
	if(IO):
		GPIO.output(FAN_PIN, False)