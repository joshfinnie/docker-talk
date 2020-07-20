FROM python:3

ADD requirements.txt /
ADD script.py /

RUN pip install -r requirements.txt

CMD python ./script.py
