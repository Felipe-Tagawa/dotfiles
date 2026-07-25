#!/bin/bash

# Script para iniciar o daemon de clipboard

# Inicia o wl-paste que envia para cliphist
wl-paste --type text --watch cliphist store
wl-paste --type image --watch cliphist store