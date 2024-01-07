FROM alpine:3.8
LABEL maintainer="GettionHub <email-url@qq.com>"

ENV VERSION 0.53.2
ENV TZ=Asia/Shanghai
WORKDIR /

RUN apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM=amd64 ; \
	elif [ "$(uname -m)" = "aarch64" ]; then export PLATFORM=arm64 ; \
	elif [ "$(uname -m)" = "armv7" ]; then export PLATFORM=arm ; \
	elif [ "$(uname -m)" = "armv7l" ]; then export PLATFORM=arm ; \
	elif [ "$(uname -m)" = "armhf" ]; then export PLATFORM=arm ; fi \
	&& wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_${PLATFORM}.tar.gz \
	&& tar xzf frp_${VERSION}_linux_${PLATFORM}.tar.gz \
	&& cd frp_${VERSION}_linux_${PLATFORM} \
	&& mkdir /frp \
	&& mv frpc frpc.ini /frp \
	&& cd .. \
	&& rm -rf *.tar.gz frp_${VERSION}_linux_${PLATFORM}

VOLUME /frp

CMD /frp/frpc -c /frp/frpc.ini