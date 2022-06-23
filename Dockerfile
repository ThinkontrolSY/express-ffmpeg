FROM lsiobase/ffmpeg:bin as binstage
FROM node:latest

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

# Add files from binstage
COPY --from=binstage / /

RUN \
    echo "**** install runtime ****" && \
    apt-get update && \
    apt-get install -y \
    i965-va-driver \
    libexpat1 \
    libgl1-mesa-dri \
    libglib2.0-0 \
    libgomp1 \
    libharfbuzz0b \
    libv4l-0 \
    libx11-6 \
    libxcb1 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libxext6 \
    libxml2 \
    ocl-icd-libopencl1 && \
    echo "**** clean up ****" && \
    rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*

EXPOSE 3000

CMD [ "node", "app.js" ]