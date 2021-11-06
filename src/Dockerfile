ARG BASE="mcr.microsoft.com/windows/nanoserver:ltsc2022"
ARG TRAEFIKVERSION="v2.5.3"

FROM --platform=linux/amd64 curlimages/curl as bins
ARG TRAEFIKVERSION

WORKDIR /bins
RUN curl -Lo traefik.zip https://github.com/traefik/traefik/releases/download/${TRAEFIKVERSION}/traefik_${TRAEFIKVERSION}_windows_amd64.zip
RUN unzip traefik.zip

FROM $BASE
USER ContainerAdministrator
COPY --from=bins /bins/traefik.exe /traefik.exe
EXPOSE 80
EXPOSE 443
EXPOSE 8080
ENTRYPOINT [ "/traefik.exe" ]

