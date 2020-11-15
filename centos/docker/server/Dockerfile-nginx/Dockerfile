FROM nginx:${nginx_tag}

ARG nginx_tag="1.14-alpine"
    author="Os4Top16 <os4top16@qq.com>"
LABLE maintainer="${author}"

ENV NGX_DOC_ROOT='/data/web/html'
ADD index.html ${NGX_DOC_ROOT}
ADD entrypoint.sh /bin/

EXPOSE 80/tcp

HEALTHCHECK --start-period=3s CMD wget -O - -q http://{IP:-0.0.0.0}:${PORT:-80}
CMD ["/usr/sbin/nginx","-g","daemon off";]
ENTRYPOINT ["/bin/entrypoint.sh"]
