FROM zklcdc/go-bingai-pass:latest

ENV GBP_USER ${GBP_USER:-gbp}
ENV GBP_USER_ID ${GBP_USER_ID:-1000}

WORKDIR /app

USER root

RUN apt-get update && apt-get install -y --no-install-recommends curl

RUN curl -L https://github.com/Harry-zklcdc/go-proxy-bingai/releases/latest/download/go-proxy-bingai-linux-amd64.tar.gz -o go-proxy-bingai-linux-amd64.tar.gz && \
    tar -zxvf go-proxy-bingai-linux-amd64.tar.gz && \
    chmod +x go-proxy-bingai

RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared && \
    chmod +x cloudflared

RUN apt-get remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm go-proxy-bingai-linux-amd64.tar.gz

COPY docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

USER $GBP_USER

ENV PORT=8080
ENV BYPASS_SERVER=http://localhost:45678

EXPOSE 8080

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
