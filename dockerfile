FROM felddy/foundryvtt:release

# Usa el release directo (sin autenticación de cuenta)
ARG FOUNDRY_RELEASE_URL
ENV FOUNDRY_RELEASE_URL=${FOUNDRY_RELEASE_URL}
ENV FOUNDRY_PORT=${PORT:-3000}

# Exponemos el puerto dinámico
EXPOSE ${FOUNDRY_PORT}/TCP

# Creamos el directorio de instalación si no existe
RUN mkdir -p /foundryvtt

# Descargar e instalar Foundry desde el release URL
RUN curl -fsSL "${FOUNDRY_RELEASE_URL}" -o /tmp/foundry.zip && \
    unzip /tmp/foundry.zip -d /foundryvtt && \
    rm /tmp/foundry.zip

# Cambiar a directorio de trabajo
WORKDIR /foundryvtt

ENTRYPOINT ["node"]
CMD ["resources/app/main.mjs", "--port", "${FOUNDRY_PORT}", "--headless", "--noupdate", "--dataPath=/data"]

HEALTHCHECK --start-period=3m --interval=30s --timeout=5s CMD [ "curl", "-f", "http://localhost:${FOUNDRY_PORT}/" ] || exit 1
