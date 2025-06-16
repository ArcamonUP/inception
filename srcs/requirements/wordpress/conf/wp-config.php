<?php
define( 'DB_NAME', 'db1' );
define( 'DB_USER', 'db1_user' );
define( 'DB_PASSWORD', 'db1_pwd' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

$table_prefix = 'wp_';

define('WP_DEBUG', true);

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
?>
