#!/usr/bin/php
<?php
function main()
{
	global $argc, $argv;
	$port = isset($argv[1]) ? intval($argv[1]) : 12345;
    $sock = socket_create(AF_INET, SOCK_DGRAM, 0);

    if(!$sock) {
        exit('can not create socket: ' . socket_strerror(socket_last_error()));
    }

    if (!socket_bind($sock, "0.0.0.0", $port)) {
        socket_close($sock);
        exit('can not bind socket: ' . socket_strerror(socket_last_error()));
    }
    
	while(true) {
        $len = socket_recvfrom($sock, $recvData, 65536, 0, $udpRemoteIp, $udpRemotePort);
        if($len === false) {
            $errno = socket_last_error();
            exit("socket recvfrom failed: $errno " . socket_strerror($errno));
        }
		echo $recvData . PHP_EOL;
	}
}

main();
