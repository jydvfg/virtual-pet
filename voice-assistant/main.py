import pyaudio
import json
import subprocess
from vosk import Model, KaldiRecognizer



model_path = "/home/jydvfg/Coding/Godot/tiny-pet/voice-assistant/vosk-model-small-en-us-0.15"
model = Model(model_path)
recognizer = KaldiRecognizer(model, 16000)


mic = pyaudio.PyAudio()


for i in range(mic.get_device_count()):
    info = mic.get_device_info_by_index(i)
    if info["maxInputChannels"] > 0:
        print(f"Index {i}: {info['name']} (in: {info['maxInputChannels']})")

DEVICE_INDEX = 14  

stream = mic.open(
    format=pyaudio.paInt16,
    channels=1,
    rate=16000,
    input=True,
    output=False,                    
    input_device_index=DEVICE_INDEX, 
    frames_per_buffer=8192
)

stream.start_stream()
print("Listening... (say something)")

while True:
    data = stream.read(4096)         
    if recognizer.AcceptWaveform(data):
        result = json.loads(recognizer.Result())
        text = result.get("text", "")
        if text:
            print(f"You said: {text}")