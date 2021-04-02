FROM jwilder/nginx-proxy
RUN { \
     echo 'server_tokens off;'; \
      echo 'client_max_body_size 5M;'; \
    } >> /etc/nginx/conf.d/mmiwg2s_proxy.conf
RUN { \
     echo 'server_tokens off;'; \
      echo 'client_max_body_size 5m;'; \
    } >> /etc/nginx/mmiwg2s_proxy.conf