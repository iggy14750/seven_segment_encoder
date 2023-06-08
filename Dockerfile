# syntax=docker/dockerfile:1
   
#FROM node:18-alpine
#FROM ubuntu:latest
FROM ghdl/ghdl:bullseye-llvm-9
WORKDIR /app
COPY . .
#RUN yarn install --production
#RUN apt update \
  #&& apt install -y --no-install-recommends python3
#CMD ["node", "src/index.js"]
#CMD ["bash", "UVVM/.github/workflows/test-ghdl.yml"]
#CMD ["./UVVM/script/compile_all.sh", "ghdl"]
CMD ["bash", "./compile.sh"]
#EXPOSE 3000

