import pyaudio
import json
import subprocess
import wave
import os
from vosk import Model, KaldiRecognizer
from piper import PiperVoice
from llama_cpp import Llama

model_path = "/home/jydvfg/Coding/Godot/tiny-pet/voice-assistant/vosk-model-small-en-us-0.15"
model = Model(model_path)
recognizer = KaldiRecognizer(model, 16000)
voice = PiperVoice.load("voices/en_US-lessac-medium.onnx")
llm = Llama(
    model_path="model/qwen2.5-1.5b-instruct-q4_k_m.gguf",
    n_ctx=512,       
    n_gpu_layers=0   
)
mic = pyaudio.PyAudio()
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

def get_user_prompt():
    while True:
        data = stream.read(4096)         
        if recognizer.AcceptWaveform(data):
            result = json.loads(recognizer.Result())
            text = result.get("text", "")
            if text:
                print(f"You said: {text}")
                return text

def query_llm(prompt):
    print("Thinking...")
    formatted_prompt = f"<|im_start|>user\n{prompt}<|im_end|>\n<|im_start|>assistant\n"
    
    output = llm(
        formatted_prompt,
        max_tokens=64,
        temperature=0.7,
        stop=["<|im_end|>"]
    )
    
    response = output["choices"][0]["text"].strip()
    print(f"LLM Response: {response}")
    return response

def generate_audio_response(text_to_speak):
    if not text_to_speak:
        print("No text provided for audio generation.")
        return

    with wave.open("python_out.wav", "wb") as wf:
        voice.synthesize_wav(text_to_speak, wf)
    print("Audio file written successfully!")
    try:
        subprocess.run(["aplay","python_out.wav"], check=True)
    except FileNotFoundError:
        print("File not found")
    except subprocess.CalledProcessError as e:
        print("Failed to play audio")

user_prompt = get_user_prompt()
inference = query_llm(user_prompt)
generate_audio_response(inference)