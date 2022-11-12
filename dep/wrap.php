#!/usr/bin/env php
<?php
	require 'banbuilder/src/CensorWords.php';

	$str = stream_get_contents(STDIN);
	print(new Snipe\BanBuilder\CensorWords)->censorString($str)['clean'];
?>
