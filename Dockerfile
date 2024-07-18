FROM nvcr.io/nvidia/pytorch:24.06-py3

RUN pip install flash_attn
WORKDIR /app
COPY test.py /app
RUN python test.py

CMD ["python", "test.py"]