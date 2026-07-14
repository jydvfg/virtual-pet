import json
import subprocess
import wave
import os
from piper import PiperVoice
from llama_cpp import Llama
from audio_producer import get_user_prompt
from intent_router import listen

voice = PiperVoice.load("voices/en_US-lessac-medium.onnx")
llm = Llama(
    model_path="model/qwen2.5-1.5b-instruct-q4_k_m.gguf",
    n_ctx=512,       
    n_gpu_layers=0   
)

def query_llm(prompt):
    print("Thinking...")
    formatted_prompt = f"<|im_start|>user\n{prompt}<|im_end|>\n<|im_start|>assistant\n"
    
    output = llm.create_chat_completion(
        messages=[
            {
                "role": "system",
                "content": "You are a helpful, brief voice assistant for a smart pet device. Speak directly to the user."
            },
            {
                "role": "user",
                "content": prompt
            }
        ],
        max_tokens=64,
        temperature=0.7
    )
    
    response = output["choices"][0]["message"]["content"].strip()
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

for raw_prompt in get_user_prompt():
    listen(raw_prompt)
    inference = query_llm(user_prompt)
    generate_audio_response(inference)