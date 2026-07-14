import socket
from dotenv import load_dotenv
import os

load_dotenv(override=True)

def listen(input):
    if "pet" in input:
        pet_handler(input)

def pet_handler(prompt):
    host = os.getenv("LOCALHOST")
    port = 9999

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((host, port))
        encoded_string = prompt.encode("utf-8")
        s.sendall(encoded_string)
