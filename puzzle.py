from enigma.machine import EnigmaMachine

keyData = ["10110111", "10110111", "11011111",
           "10110111", "10101001", "11011111",
           "10101001", "11011111", "10111101",
           "11011111", "11001110", "11011111",
           "11001101", "11001111", "11011111",
           "11001110", "11001110", "11011111",
           "10111110", "10101001", "11011111",
           "10111101", "10101100", "11011111",
           "10111100", "10111000", "11011111",
           "10111011", "10110011", "11011111",
           "10111001", "10101010", "11011111",
           "10110111", "10100101", "11011111",
           "10110110", "10110001", "11011111",
           "10110100", "10110010", "11011111",
           "10110000", "10101000", "11011111",
           "10101101", "10100111", "11011111",
           "10101000", "10100111", "10111100"]

message = """LMCJXTTVUWUGUQRWFAGNTRPHNXVMZFBVAGSWQVZQCZKDXO
WTDLMNRYNTVFFALXLNMWWAERLAHDCJPKWEYRZOETIWVNFLC
ETHFZTTBOYDODNZBTDGOYKPMHZNOBICFHRNVBULUNLTJPVRA
HXMFDKXYVDCRNMKQVSLLDVANJJHJKUEUYJBLZHHHEDLYNPFN
ZJRADXFBNTQAPCAADUQZHZTBHDWQHWDMCOZRTQAKUXZSCX
RZNSZNCTWMEHMTSXRYMANXPMCURNGDERSIPVLLOUPYXECS
LGBYFDXIEPLBHIRJTOYMCYCADOFBHNTODPTCWPMKJXKVSWH
TINWJKPHLXDSPRMYGIEDVJWKTDCOGTTLGTHZFWBEXZLECRTI
HANJQBDFCLJYRHLLHUJZLFMFLQTHJHZDAKDHBOAVBANINGRK
BDNEOTULNIDOZWLRCENSRHROXCYFPSFQMONHBQAEELLOH
GUEYKNARFYJJOURVGONUMGZNGYOTSZLIODFTGIHVPULLLH
RYCFLORWZK""".replace('\n', '').replace('\r', '').replace(' ', '')

ansData = []
for i in keyData:
    ansData.append(int(i, 2) ^ int("11111111", 2))

ansData[0] = ansData[0] + 1
ansData[1] = ansData[1] + 1
ansData[3] = ansData[3] + 1

myString = ""
for i in ansData:
    myString += chr(i)

machine = EnigmaMachine.from_key_sheet(
               rotors=myString[0:7],
               reflector=myString[8],
               ring_settings=[int(myString[10], 10), int(myString[11:14], 10), int(myString[14:17], 10)],
               plugboard_settings=myString[18:47])

machine.set_display(myString[48:])

plaintext = machine.process_text(message).replace('X', ' ')

