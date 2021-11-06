ARG BASE="mcr.microsoft.com/windows/servercore:1809"
ARG TRAEFIKVERSION="v2.5.3"

FROM --platform=linux/amd64 curlimages/curl as bins
ARG TRAEFIKVERSION

WORKDIR /bins
RUN curl -Lo traefik.zip https://github.com/traefik/traefik/releases/download/${TRAEFIKVERSION}/traefik_${TRAEFIKVERSION}_windows_amd64.zip
RUN unzip traefik.zip

FROM $BASE
ENV PATH="C:\Program Files\PowerShell;C:\utils;C:\Windows\system32;C:\Windows;"
COPY --from=bins /bins/traefik.exe /traefik.exe
EXPOSE 80
ENTRYPOINT [ "/traefik.exe" ]

