<?php

/**
 *  PHP Mikrotik Billing (https://github.com/hotspotbilling/phpnuxbill/)
 *  by https://t.me/ibnux
 *
 *  This file is for Text Transformation
 **/

class Text
{

    public static function toHex($string)
    {
        return "\x" . implode("\x", str_split(array_shift(unpack('H*', $string)), 2));
    }

    public static function alphanumeric($str, $tambahan = "")
    {
        return preg_replace("/[^a-zA-Z0-9" . $tambahan . "]+/", "", $str);
    }

    public static function numeric($str)
    {
        return preg_replace("/[^0-9]+/", "", $str);
    }

    public static function ucWords($text)
    {
        return ucwords(str_replace('_', ' ', $text));
    }

    public static function randomUpLowCase($text)
    {
        $jml = strlen($text);
        $result = '';
        for ($i = 0; $i < $jml; $i++) {
            if (rand(0, 99) % 2) {
                $result .= strtolower(substr($text, $i, 1));
            } else {
                $result .= substr($text, $i, 1);
            }
        }
        return $result;
    }

    public static function maskText($text)
    {
        $len = strlen($text);
        if ($len < 3) {
            return "***";
        } else if ($len < 5) {
            return substr($text, 0, 1) . "***" . substr($text, -1, 1);
        } else if ($len < 8) {
            return substr($text, 0, 2) . "***" . substr($text, -2, 2);
        } else {
            return substr($text, 0, 4) . "******" . substr($text, -3, 3);
        }
    }

    public static function sanitize($str)
    {
        return preg_replace("/[^A-Za-z0-9]/", '_', $str);;
    }

    public static function is_html($string)
    {
        return preg_match("/<[^<]+>/", $string, $m) != 0;
    }

    public static function convertDataUnit($datalimit, $unit = 'MB')
    {
        $unit = strtoupper($unit);
        if ($unit == 'KB') {
            return $datalimit * 1024;
        } elseif ($unit == 'MB') {
            return $datalimit * 1048576;
        } elseif ($unit == 'GB') {
            return $datalimit * 1073741824;
        } elseif ($unit == 'TB') {
            return $datalimit * 1099511627776;
        } else {
            return $datalimit;
        }
    }

    // echo Json array to text
    public static function jsonArray2text($array, $start = '', $result = '')
    {
        foreach ($array as $k => $v) {
            if (is_array($v)) {
                $result .= self::jsonArray2text($v, "$start$k.", '');
            } else {
                $result .= "$start$k = " . strval($v) . "\n";
            }
        }
        return $result;
    }

    public static function jsonArray21Array($array){
        $text = self::jsonArray2text($array);
        $lines = explode("\n", $text);
        $result = [];
        foreach($lines as $line){
            $parts = explode(' = ', $line);
            if(count($parts) == 2){
                $result[trim($parts[0])] = trim($parts[1]);
            }
        }
        return $result;
    }

    /**
     * ...$data means it can take any number of arguments.
     * it can url($var1, $var2, $var3) or url($var1)
     * and variable will be merge with implode
     * @return string the URL with all the arguments combined.
     */
    public static function url(...$data){
        global $config;
        $url = implode("", $data);
        if ($config['url_canonical'] == 'yes') {
            $u = str_replace('?_route=', '', U);
            $pos = strpos($url, '&');
            if ($pos === false) {
                return $u . $url;
            } else {
                return $u . substr($url, 0, $pos) . '?' . substr($url, $pos + 1);
            }
        } else {
            return U . $url;
        }
    }

    public static function fixUrl($url){
        //if url dont have ? then add it with replace first & to ?
        if(strpos($url, '?') === false && strpos($url, '&')!== false){
            return substr($url, 0, strpos($url, '&')). '?'. substr($url, strpos($url, '&')+1);
        }
        return $url;
    }

    // this will return & or ?
    public static function isQA(){
        global $config;
        if ($config['url_canonical'] == 'yes') {
            return '?';
        } else {
            return '&';
        }
    }
}
