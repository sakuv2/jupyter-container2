FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# install sshd
RUN apt update && apt install -y openssh-server && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    echo "export PATH=$PATH" >> /etc/profile && \
    echo "ldconfig" >> /etc/profile
ENV NOTVISIBLE "in users profile"
EXPOSE 22

RUN apt install -y \
    gconf-service libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
    libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 \
    libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 \
    libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxss1 libxtst6 \
    libappindicator1 libnss3 libasound2 libatk1.0-0 libc6 ca-certificates \
    fonts-liberation lsb-release xdg-utils wget \
    fonts-ipafont-gothic fonts-ipafont-mincho \
    libpq-dev lsof locales iproute2 language-pack-ja

# install pyenv & python
ENV PYENV_ROOT=/root/.pyenv \
    PATH=/usr/local/python-3.8.3/bin:/root/.pyenv/bin:$PATH
RUN apt install -y \
    git \
    curl \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    bzip2 \
    libbz2-dev \
    zlib1g-dev \
    libssl-dev \
    openssl \
    libgdbm-dev \
    libgdbm-compat-dev \
    liblzma-dev \
    libreadline-dev \
    libncursesw5-dev \
    libffi-dev \
    uuid-dev 
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PATH=/root/.pyenv/bin:$PATH' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile && \
    ~/.pyenv/plugins/python-build/install.sh && \
    usr/local/bin/python-build -v 3.8.3 /usr/local/python-3.8.3

# install jupyterlab
RUN pip install jupyterlab && \
    mkdir ~/.jupyter && \
    echo "\
c.NotebookApp.allow_root = True\n\
c.NotebookApp.ip = '0.0.0.0'\n\
c.NotebookApp.open_browser = False\n\
c.NotebookApp.port = 8888\n\
c.NotebookApp.notebook_dir = '/root/pyprojects'\n\
c.NotebookApp.terminado_settings = { 'shell_command': ['/usr/bin/fish'] }\
" > ~/.jupyter/jupyter_notebook_config.py

# install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python && \
    /root/.poetry/bin/poetry config virtualenvs.in-project true

# 使いやすくする
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN apt install -y software-properties-common && \
    apt-add-repository -y ppa:fish-shell/release-3 && \
    apt install -y fish && \
    apt-add-repository --remove -y ppa:fish-shell/release-3 && \
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish && \
    apt install -y vim tree htop jq && \
    pip install -U pip awscli && \
    curl https://sdk.cloud.google.com | bash

# jupyterlab extension
RUN apt-get install -y nodejs npm && \
    npm install n -g && n lts
RUN export NODE_OPTIONS=--max-old-space-size=4096 && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install plotlywidget --no-build && \
    jupyter labextension install jupyterlab-plotly --no-build && \
    jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter lab build

# ホームを後でマウントできるように一旦退避
RUN mv /root/ /cp_root/ && mkdir /root

COPY start.sh /start.sh
COPY monitoring.py /monitoring.py
COPY fish /root/.config/fish
EXPOSE 8888
ENTRYPOINT ["/start.sh"]
