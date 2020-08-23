## entrypoint
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd
