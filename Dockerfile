# This Dockerfile for workshop demo with php.

# pull base image
FROM php:7.2-apache

COPY src /var/www/html
