<?php
if(isset($GLOBALS["HTTP_RAW_POST_DATA"]))
{
	require_once('conexao.php');

	$uid = $_GET['uid'];
	//the image file name
	$fileName = $uid.'_thumb.png';
	// get the binary stream
	$im = $GLOBALS["HTTP_RAW_POST_DATA"];
	//write it
	$fp = fopen("../thumb/".$fileName, 'wb');
	fwrite($fp, $im);
	fclose($fp);
	
	//the image file name
	$streamFile = $uid .time() .'.png';
	//write it
	$fp = fopen("../streamThumb/".$streamFile, 'wb');
	fwrite($fp, $im);
	fclose($fp);
	//echo the fileName
	echo $streamFile;
}
else
{
	echo 'erro';
}
?>