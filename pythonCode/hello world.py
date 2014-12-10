
import requests
import json
import RPi.GPIO as GPIO
import time


LedPinNum = 8
ButtonPinNum = 17
GPIO.setmode(GPIO.BCM) #numbering scheme that corresponds to breakout board and pin layout
GPIO.setup(LedPinNum,GPIO.OUT) #replace pinNum with whatever pin you used, this sets up that pin as an output
GPIO.setup(ButtonPinNum)
prev_input = 0
while True:
  input = GPIO.input(ButtonPinNum) #take a reading
  if ((not prev_input) and input): #if the last reading was low and this one high, print
    #raise event and store directive number of blinks
	r = requests.post('http://cs.kobj.net/sky/event/D8193B5E-4B2F-11E4-8C99-9CD33A8D136F/123/raspberrypie/button')
	directives = json.loads(r.text)
	blinks = directives['directives'][0]['options']['blinks']
	#blink led
	for x in range(0,blinks)
	  GPIO.output(LedPinNum,GPIO.HIGH)
	  time.sleep(0.5)
	  GPIO.output(LedPinNum,GPIO.LOW)
	  time.sleep(0.5)
  prev_input = input #update previous input
  #time.sleep(0.05) #slight pause to debounce


