FROM rocker/shiny:latest

# Установка системных зависимостей (подстраховка)
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка пакетов с проверкой
RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')" \
 && Rscript -e "remotes::install_cran(c('shiny','bs4Dash','dplyr','readr','plotly','leaflet','fresh','viridis','fst','lubridate','forecast'))"

COPY ./app.R /srv/shiny-server/app.R

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]

