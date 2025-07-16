import earth_academy
import time

ip = "127.0.0.1"
port = 9876
role = "lockpick"

earth_academy.connect(role, ip, port)

message = ""

earth_academy.shields_enabled = True
earth_academy.shields_target = 100
earth_academy.shields_add = 80
earth_academy.set_shields()

while message != "quit":
    message = input('> ')
    if message == "print":
      print(f"My ID: {earth_academy.connection_id}")
      print(earth_academy.message_stack)
    elif message == "up":
        earth_academy.move("up")
    elif message == "down":
        earth_academy.move("down")
    elif message == "left":
        earth_academy.move("left")
    elif message == "right":
        earth_academy.move("right")
    elif message.split(" ")[0] in ["hack", "pick", "use", "distract"]:
        message_list = message.split(" ")
        target_id = int(message_list[1])
        match message_list[0]:
            case "hack":
                #Can send "begin" (default), "success", "failed", "cancel"
                if len(message_list) == 3:
                    earth_academy.hack(target_id, message_list[2])
                else:
                    earth_academy.hack(target_id)
            case "pick":
                #Can send "begin" (default), "success", "failed", "cancel"
                if len(message_list) == 3:
                    earth_academy.pick(target_id, message_list[2])
                else:
                    earth_academy.pick(target_id)
            case "use":
                earth_academy.use(target_id)
            case "distract":
                earth_academy.distract(target_id)
    else:
        print("Not an option.")
    time.sleep(0.1)
    for response_number in range(len(earth_academy.message_stack)):
        response = earth_academy.message_stack.pop()
        #You can iterate over the environment list and look for objects of a type relevant to your character
        if response["type"] == "environment":
            for item in response["response"]:
                if item['type'] != 'none':
                    print(item)
        elif response["type"] == "safe":
            print(response["data"])
        elif response["type"] == "begin_action":
            print(response["data"])
        elif response["type"] == "earpiece_info":
            print(response["data"])

earth_academy.disconnect()
