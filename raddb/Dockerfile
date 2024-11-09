FROM ubuntu:latest
RUN apt-get update && apt-get install -y freeradius freeradius-mysql  freeradius-utils

RUN ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/sql
RUN ln -s /etc/freeradius/3.0/mods-available/sqlcounter /etc/freeradius/3.0/mods-enabled/sqlcounter
EXPOSE 1812/udp 1813/udp
#CMD ["freeradius", "-X"] # to run in debug mode
CMD ["freeradius", "-f"]
