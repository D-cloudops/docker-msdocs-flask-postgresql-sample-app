FROM python:3.9-slim AS build

WORKDIR /app

RUN apt-get update && apt-get install -y libpq-dev gcc

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y libpq5  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/ /usr/local/

COPY --from=build /app/ /app/

EXPOSE 8000

RUN chmod u+x startup.sh

CMD ["sh", "-c", "./startup.sh"]