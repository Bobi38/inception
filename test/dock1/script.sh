#!/bin/bash
mkdir -p /test
echo "dock1: Création du fichier..."
echo 'toto' > /test/pinpin
echo 'donnes ajoute par dock1' >> /test/pinpin
echo "dock1: Fichier créé avec succès"
sleep infinity