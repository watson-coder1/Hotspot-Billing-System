<?php

/**
 * PHP Mikrotik Billing (https://github.com/hotspotbilling/phpnuxbill/)
 * by https://t.me/ibnux
 **/
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

if(isset($_GET['nux-mac']) && !empty($_GET['nux-mac'])){
    $_SESSION['nux-mac'] = $_GET['nux-mac'];
}

if(isset($_GET['nux-ip']) && !empty($_GET['nux-ip'])){
    $_SESSION['nux-ip'] = $_GET['nux-ip'];
}

// die('AFTER IP'); // Commented out to allow further execution

if(isset($_GET['nux-router']) && !empty($_GET['nux-router'])){
    $_SESSION['nux-router'] = $_GET['nux-router'];
}

// die('AFTER ROUTER'); // Commented out to allow further execution

//get chap id and chap challenge
if(isset($_GET['nux-key']) && !empty($_GET['nux-key'])){
    $_SESSION['nux-key'] = $_GET['nux-key'];
}
//get mikrotik hostname
if(isset($_GET['nux-hostname']) && !empty($_GET['nux-hostname'])){
    $_SESSION['nux-hostname'] = $_GET['nux-hostname'];
}

// die('AFTER HOSTNAME'); // Commented out to allow further execution

require_once 'system/vendor/autoload.php';
// die('AFTER AUTOLOAD'); // Commented out to allow further execution
require_once 'system/boot.php';
// die('AFTER BOOT'); // Commented out to allow further execution
App::_run();
// die('AFTER APP RUN'); // Commented out as App::_run() should handle output