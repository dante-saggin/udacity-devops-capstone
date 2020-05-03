FROM python:3.6.5-stretch

WORKDIR /app

COPY . app.py /app/

# hadolint ignore=DL3013
RUN pip install --upgrade pip && pip install -r requirements.txt


EXPOSE 80

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -v http://localhost:80/ping || exit 1

CMD ["python", "app.py"]
