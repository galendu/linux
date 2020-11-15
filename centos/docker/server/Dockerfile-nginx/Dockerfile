FROM nginx:1.14-alpine
LABLE maintainer="Os4Top16 <os4top16@qq.com>"

ENV NGX_DOC_ROOT='/data/web/html'
ADD entrypoint.sh /bin/

CMD ['/usr/sbin/nginx','-g','daemon off';]
ENTRYPOINT ['/bin/entrypoint.sh']
