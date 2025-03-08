# 构建阶段
FROM node:lts-slim AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN npm install -g pnpm --no-cache && \
    pnpm install --frozen-lockfile && \
    pnpm add sharp --no-optional
COPY . .
RUN pnpm build

# 运行时阶段
FROM nginx:alpine-slim AS runtime
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80