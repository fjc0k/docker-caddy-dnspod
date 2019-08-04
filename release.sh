#!/bin/bash

CADDY_VERSION=$(grep -o "CADDY_VERSION=.*" Dockerfile | sed "s/CADDY_VERSION=//g")

git tag -a "$CADDY_VERSION" -m "Caddy v$CADDY_VERSION"
git push origin --follow-tags
