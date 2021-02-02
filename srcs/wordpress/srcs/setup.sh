# Wordpress starting
set -x # Print commands and their arguments as they are executed
# Config wp-config.php (database mariadb)
cat << EOF > /www/wordpress/wp-config.php
<?php
# Config Mariadb | database

define('DB_NAME', '$DB_NAME');
define('DB_USER', '$DB_USER');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', '$DB_HOST');
define('DB_CHARSET', 'utf8');
define('FS_METHOD', 'direct');
define('DB_COLLATE', '');

define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

\$table_prefix = 'wp_';

define('WP_DEBUG', false);
/* C’est tout, ne touchez pas à ce qui suit ! Bonne publication. */
/** Chemin absolu vers le dossier de WordPress. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
/** Réglage des variables de WordPress et de ses fichiers inclus. */
require_once(ABSPATH . 'wp-settings.php');
?>
EOF

# connect to mariadb
# openrc
# touch /run/openrc/softlevel
# /etc/init.d/mariadb setup
# rc-service mariadb start
# mysql -h $MYSQL_IP -u wp_user -p

# PHP SERVER
php -S 0.0.0.0:5050 -t /www/wordpress
tail -f dev/null