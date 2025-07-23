from websocket import create_connection
import threading
import json

api_version = "1.00"
client_type = "python"

active = True
server_message = ''
server = None
message_stack = []

#variables from server:
#encounter_state (WAITING, IN_PROGRESS, ENDED_FAIL, ENDED_WIN, UDEAD)

playername = 'Clarence'
connection_id = 0

shields_enabled = False
shields_target = 0
shields_add = 0

server_fails = 0

#Listener thread receives responses from the server
#It writes to global variables for access via other functions
def listener(_server):
    global server_message
    global server_fails
    global active
    while active:
        try:
            server_message = _server.recv()#.decode("utf-8")
            try:
                server_response = json.loads(server_message)
                #message_stack.append(server_response)
                print(server_response)
            except:
                print("Server sent non-JSON response!")
        except Exception as e:
            print(e)
            disconnect()

#Instruction must already have at least an action
def send_instruction(instruction):
    instruction["version"] = api_version
    server.send(json.dumps(instruction))

def set_shields():
    instruction = {"action":"shields", "enabled":shields_enabled, "target_level":shields_target, "adjust": shields_add}
    send_instruction(instruction)

def register(username, pin):
    instruction = {"action":"register", "username":username, "pin":pin}
    send_instruction(instruction)

def sign_in(username, pin):
    pass

def disconnect():
    print("Disconnecting...")
    global server
    global active
    active = False
    server.close()

def connect(_ip, _port):
    global server
    connected = False
    try:
        server = create_connection(f"ws://{_ip}:{_port}")
        instruction = {"action":"join"}
        send_instruction(instruction)
        listener_thread = threading.Thread(target = listener, args=(server,))
        listener_thread.start()
        connected = True
    except:    
        print("Error connecting to the server.")
    return connected
