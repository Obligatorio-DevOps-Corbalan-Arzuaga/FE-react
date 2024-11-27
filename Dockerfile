FROM node:18 AS build-local

WORKDIR /FE-react

COPY package*.json ./

RUN npm install

COPY apps/catalog ./apps/catalog \
    libs ./libs \
    tsconfig.base.json ./ \
    nx.json ./ \
    workspace.json ./ \
    babel.config.json ./

RUN npm run build -- --project=catalog --configuration=production

FROM nginx:alpine AS prueba-local-nginx

COPY --from=build-local /FE-react/dist/apps/catalog /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
