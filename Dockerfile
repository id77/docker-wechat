FROM id77/wine:latest

USER root
RUN apt update && apt install -y \
    pev \
    sudo \
  && apt-get autoremove -y \
  && apt-get clean \
  && chown user /home \
  && rm -fr /tmp/*

RUN echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

ENV \
  LANG=zh_CN.UTF-8 \
  LC_ALL=zh_CN.UTF-8

COPY --chown=user:group container_root/ /
COPY [A-Z]* /
COPY VERSION /VERSION.docker-wechat

USER user
RUN bash -x /setup.sh
ENTRYPOINT [ "/entrypoint.sh" ]

#
# Huan(202004): VOLUME should be put to the END of the Dockerfile
#   because it will frezz the contents in the volume directory
#   which means the content in the directory will lost all changes after the VOLUME command
#
RUN mkdir -p "/home/user/WeChat Files" "/home/user/.wine/drive_c/users/user/Application Data" \
  && chown user:group "/home/user/WeChat Files" "/home/user/.wine/drive_c/users/user/Application Data"
VOLUME [\
  "/home/user/WeChat Files", \
  "/home/user/.wine/drive_c/users/user/Application Data" \
]

LABEL \
    org.opencontainers.image.authors="Huan LI (李卓桓) <zixia@zixia.net>" \
    org.opencontainers.image.description="DoChat(盒装微信) is a Dockerized WeChat(微信) PC Windows Client for Linux." \
    org.opencontainers.image.documentation="https://github.com/huan/docker-wechat/#readme" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.source="git@github.com:huan/docker-wechat.git" \
    org.opencontainers.image.title="DoChat" \
    org.opencontainers.image.url="https://github.com/huan/docker-wechat" \
    org.opencontainers.image.vendor="Huan LI (李卓桓)"
