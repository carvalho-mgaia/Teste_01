<?php
if(isset($GLOBALS["HTTP_RAW_POST_DATA"]))
{
	require_once('conexao.php');

	$uid = $_GET['uid'];
	$name = $_GET['nome'];
	$birthday = $_GET['birthday'];
	$location = $_GET['location'];
	
	//the image file name
	$fileName = $uid.'.png';
	// get the binary stream
	$im = $GLOBALS["HTTP_RAW_POST_DATA"];
	//write it
	$fp = fopen('../avatares/'.$fileName, 'wb');
	fwrite($fp, $im);
	fclose($fp);
	//echo the fileName
	echo $fileName;
	
	$query = "INSERT INTO usuarios (UID, nome, birthday, location) VALUES ('$uid','$name', STR_TO_DATE('$birthday','%m/%d/%Y'),'$location')";
	$sql = mysql_query($query);

	if($sql)
	{
		echo 'sucesso';
	}
	else
	{
		echo 'erro';
	}
}
else
{
	echo 'erro';
}
?>