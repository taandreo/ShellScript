#!/bin/bash

# Script simples para realizar a troca de extensão de um ou mais arquivos no diretório atual.
#
# Versão: 1.0 
# Autor: Tairan Andreo


EXT_1='.zip'
EXT_2='.cbz'

LS_DIR=$(ls | egrep "\\$EXT_1\$")


echo $LS_DIR

for arquivo in $LS_DIR
do
    mv $arquivo $(echo $arquivo | sed -r "s/\\$EXT_1\$/\\$EXT_2/g")
done 
