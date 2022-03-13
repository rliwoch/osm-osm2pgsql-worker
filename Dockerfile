FROM ubuntu:20.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive 
ENV DB_GIS_DB=gis
ENV DB_HOST=localhost
ENV DB_PORT=5432
ENV DB_USER=postgres
ENV DB_PASS=pass
ENV PG_CONN_STRING=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_GIS_DB?user=$DB_USER&password=$DB_PASS

RUN apt update && \
 	apt install -y make cmake g++ libboost-dev libboost-system-dev \
  	libboost-filesystem-dev libexpat1-dev zlib1g-dev \
  	libbz2-dev libpq-dev libproj-dev lua5.3 liblua5.3-dev pandoc libluajit-5.1-dev git

RUN	git clone https://github.com/openstreetmap/osm2pgsql.git && \
	cd osm2pgsql && \
	mkdir build && cd build && \
	cmake -D WITH_LUAJIT=ON .. && \
	export CORES=$(getconf _NPROCESSORS_ONLN) && \
	make -j $CORES && \
	make install

CMD ["sh", "-c", "osm2pgsql -d ${PG_CONN_STRING} --create --slim -G --hstore --tag-transform-script ${INIT_FOLDER}/openstreetmap-carto.lua -C 2500 --number-processes ${NUM_PROC} -S ${INIT_FOLDER}/openstreetmap-carto.style ${INIT_FOLDER}/${MAP_NAME}"]
