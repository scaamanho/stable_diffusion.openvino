FROM python:3.9.9-bullseye

WORKDIR /src

RUN apt-get update && \
    apt-get install -y \
    libgl1 libglib2.0-0 && \
    python3 -m pip install --upgrade pip

COPY requirements.txt /src/

RUN pip3 install -r requirements.txt

COPY stable_diffusion_engine.py demo.py demo_web.py /src/
COPY data/ /src/data/

# download models
RUN python3 demo.py --num-inference-steps 1 --prompt "test" --output /tmp/test.jpg

ENV INFERENCE_NUM_THREADS=0
EXPOSE 8501

#ENTRYPOINT ["python3", "demo_web.py"]
ENTRYPOINT ["streamlit", "run"]
CMD ["demo_web.py"]
