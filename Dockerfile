# stage 0 - Building front end assets
FROM node:12.16.3-alpine as build
# create work directory
WORKDIR /app
# Copy package.json
COPY package*.json ./
# Install node_modules
RUN npm install
# Copy node_moduiles into working directory
COPY . .
# Build for production
RUN npm run build

# Stage one - Serving frontend assets
FROM fholzer/nginx-brotli:v1.12.2
# Create working directory
WORKDIR /etc/nginx
# Add ngnix configuration to container
ADD nginx.conf /etc/nginx
# Copy our build assets
COPY --from=build /app/build /usr/share/nginx/html
# Expose our container ports
EXPOSE 443
# Start nginx server
CMD ["nginx", "-g", "daemon off;"]