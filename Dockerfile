FROM node:20

# install git
RUN apt update 
RUN apt install git


ARG DEBIAN_FRONTEND=noninteractive

ENV BING_HEADER ""

# Set home to the user's home directory
ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

# Set up a new user named "user" with user ID 1000
RUN useradd -o -u 1000 user && mkdir -p $HOME/app && chown -R user $HOME

# Switch to the "user" user
USER user

WORKDIR $HOME/app


RUN git clone https://github.com/Harry-zklcdc/go-proxy-bingai.git bingo
RUN chown -R user $HOME/app/bingo
WORKDIR $HOME/app/bingo
RUN npm install
RUN npm run build

ENV PORT 7860
EXPOSE 7860

CMD npm start
