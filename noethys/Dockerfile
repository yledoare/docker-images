FROM python:3.10.2

RUN useradd -d /noethys noethys
RUN apt-get update && apt-get install -y git
RUN mkdir -p /noethys
RUN chown -R noethys:noethys /noethys
USER noethys
RUN cd /noethys \
        && git clone https://github.com/Noethys/Connecthys.git \
        && cd Connecthys \
        && pip3 install -r requirements.txt
#RUN pip3 install updater
#RUN pip3 uninstall -y click
#RUN pip3 install black
#RUN pip3 install click

VOLUME /noethys/Connecthys
WORKDIR /noethys/Connecthys/connecthys
CMD ["python3","run.py"]
