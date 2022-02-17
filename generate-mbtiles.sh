#!/bin/bash
echo "Téléchargement des fichiers sources"
mkdir -p sources
wget -P sources -N http://etalab-datasets.geo.data.gouv.fr/contours-administratifs/latest/geojson/communes-5m.geojson.gz
wget -P sources -N http://etalab-datasets.geo.data.gouv.fr/contours-administratifs/latest/geojson/departements-5m.geojson.gz
wget -P sources -N http://etalab-datasets.geo.data.gouv.fr/contours-administratifs/latest/geojson/regions-5m.geojson.gz

echo "Génération des tuiles vectorielles découpage administratif"
mkdir -p dist

#echo "Régions"
tippecanoe -l regions --no-tile-stats --drop-densest-as-needed --detect-shared-borders -Z3 -z12  -f -o dist/regions.mbtiles sources/regions-5m.geojson.gz

#echo "Départements"
tippecanoe -l departements --no-tile-stats --drop-densest-as-needed --detect-shared-borders -Z3 -z12 -f -o dist/departements.mbtiles sources/departements-5m.geojson.gz

echo "Communes"
tippecanoe -l communes --no-tile-stats --drop-densest-as-needed --detect-shared-borders -Z8 -z12 -f -o dist/communes.mbtiles sources/communes-5m.geojson.gz

echo "Merge des tuiles vectorielles"
tile-join --attribution=Etalab --name=decoupage-administratif --no-tile-size-limit --no-tile-stats -f --output dist/decoupage-administratif.mbtiles dist/communes.mbtiles dist/departements.mbtiles dist/regions.mbtiles

echo "Terminé"
