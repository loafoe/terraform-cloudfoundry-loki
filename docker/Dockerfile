FROM grafana/loki:2.2.1
COPY run.sh /loki/run.sh
USER root
RUN chown loki /loki/run.sh && chmod +x /loki/run.sh
USER loki
EXPOSE 3100
