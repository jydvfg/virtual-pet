import json
import pyaudio
from vosk import Model, KaldiRecognizer

mic = pyaudio.PyAudio()

try:
    default_device_info = mic.get_default_input_device_info()
    DEVICE_INDEX = default_device_info['index']
    print(f"--> Automatically bound to default mic: {default_device_info['name']} (Index {DEVICE_INDEX})")
except IOError:
    DEVICE_INDEX = None
    for i in range(mic.get_device_count()):
        dev_info = mic.get_device_info_by_index(i)
        if dev_info.get('maxInputChannels', 0) > 0:
            DEVICE_INDEX = i
            print(f"--> Fallback: Bound to input device: {dev_info['name']} (Index {DEVICE_INDEX})")
            break
    if DEVICE_INDEX is None:
        raise RuntimeError("No input microphone detected on this system!")

model_path = "/home/jydvfg/Coding/Godot/tiny-pet/voice-assistant/vosk-model-small-en-us-0.15"
model = Model(model_path)
recognizer = KaldiRecognizer(model, 16000)

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

def get_user_prompt():
    while True:
        data = stream.read(4096, exception_on_overflow=False)  # Added safety to prevent buffer crashes on slow loops       
        if recognizer.AcceptWaveform(data):
            result = json.loads(recognizer.Result())
            text = result.get("text", "")
            if text:
                print(f"You said: {text}")
                yield text