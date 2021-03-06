# # Lets redirect all www.* requests to the non-www domain
# server {
#   server_name  www.domain.com;
#   rewrite ^ http://domain.com$request_uri permanent;
#   access_log off;
# }
#
# server {
#   server_name  domain.com;
#   root   /var/www/domain.com/htdocs;
#   access_log /var/log/nginx/domain.access.log;
#
#   # Give users their static files... FAST
#   include /etc/nginx/include/serve_static;
#   # Let's give it PHP powers!
#   include /etc/nginx/include/serve_php;
#
#   # Sample redirect
#   rewrite ^/old/$ http://domain.com/new/ permanent;
#
#   # Redirect every access to a subdirectory except a given your IP
#   if ( $remote_addr != 123.123.123.123 ) {
#     rewrite ^/$ http://domain.com/ingsoon/ redirect;
#   }
# }
#
# # Sample subdomain for serving static assets (eg. CSS/JS/IMG/etc)
# server {
#   server_name  assets.domain.com;
#   root   /var/www/domain.com/subdomains/assets;
#   access_log off;
#
#   include /etc/nginx/include/serve_static;
# }
#
#
# # Look, Ma: a PHP-powered subdomain!!
# server {
#   server_name  php.domain.com;
#   root   /var/www/domain.com/subdomains/php;
#   access_log /var/log/nginx/php.domain.access.log;
#
#   include /etc/nginx/include/serve_static;
#   include /etc/nginx/include/serve_php;
# }
#
#
# # Example with a few more complex redirects, like the ones you'd put in a .htaccess
# # This subdomain mimicks my configuration for http://pongsocket.com/tweetnest/
# server {
#   server_name  nest.domain.com;
#   root   /var/www/domain.com/subdomains/nest;
#   access_log /var/log/nginx/nest.domain.access.log;
#
#   include /etc/nginx/include/serve_static;
#   include /etc/nginx/include/serve_php;
#
#   rewrite ^/sort/?$ /./sort.php last;
#   rewrite ^/favorites/?$ /./favorites.php last;
#   rewrite ^/search/?$ /./search.php last;
#   rewrite ^/([0-9]+)/([0-9]+)/?$ /./month.php?y=$1&m=$2;
#   rewrite ^/([0-9]+)/([0-9]+)/([0-9]+)/?$ /./day.php?y=$1&m=$2&d=$3;
# }