FROM ghcr.io/cirruslabs/flutter:3.35.6 AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

ARG DIMIGOIN_FLUTTER_FIREBASE
ARG DIMIGOIN_FLUTTER_ENV

RUN mkdir -p env \
    && echo -n "$DIMIGOIN_FLUTTER_FIREBASE" | base64 -d > lib/firebase_options.dart \
    && echo -n "$DIMIGOIN_FLUTTER_ENV" | base64 -d > env/.env

RUN flutter build web --release

FROM nginx:1.27.2-alpine-slim

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
