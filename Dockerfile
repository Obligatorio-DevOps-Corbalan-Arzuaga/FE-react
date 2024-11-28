FROM node:18 AS build-local

WORKDIR /FE-react

COPY package*.json ./

RUN npm install --ignore-scripts && mkdir -p /FE-react/config

COPY apps/catalog/src ./apps/catalog/src \
     apps/catalog/project.json ./apps/catalog/ \
     apps/catalog/tsconfig.app.json ./apps/catalog/ \
     nx.json ./config/ \
     workspace.json ./config/ \
     babel.config.json ./config/ \
     tsconfig.base.json ./config/

RUN npm run build -- --project=catalog --configuration=production

FROM nginx:alpine AS prueba-local-nginx

COPY --from=build-local /FE-react/dist/apps/catalog /usr/share/nginx/html

USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
