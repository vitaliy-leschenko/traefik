ARG BASE="mcr.microsoft.com/windows/nanoserver:ltsc2022"
ARG NETAPI="mcr.microsoft.com/windows/servercore:ltsc2022"
ARG TRAEFIKVERSION="v2.5.3"

FROM --platform=linux/amd64 curlimages/curl as bins
ARG TRAEFIKVERSION

WORKDIR /bins
RUN curl -Lo traefik.zip https://github.com/traefik/traefik/releases/download/${TRAEFIKVERSION}/traefik_${TRAEFIKVERSION}_windows_amd64.zip
RUN unzip traefik.zip

FROM $NETAPI as netapi

FROM $BASE
USER ContainerAdministrator
ENV PATH="C:\Windows\system32;C:\Windows;"
COPY --from=bins /bins/traefik.exe /traefik.exe
COPY --from=netapi /Windows/System32/netapi32.dll /Windows/System32
EXPOSE 80
EXPOSE 443
EXPOSE 8080
ENTRYPOINT [ "/traefik.exe" ]

