FROM cypress/base:10
COPY . /workspace
WORKDIR /workspace
RUN npm install --save-dev cypress
RUN $(npm bin)/cypress verify
