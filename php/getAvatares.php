<?php
	require_once('conexao.php');
	
	$query = $_POST['query'];
	
	echo $query;

	$sql = mysql_query($query);
	$dados = "";

	if(mysql_num_rows($sql) > 0)
	{
		// Retorna uma matriz que corresponde a linha obtida e move o ponteiro interno dos dados adiante.
		while($n = mysql_fetch_array($sql))
		{
			$dados .= '&'.$n['UID'];
			$dados .= '&'.$n['nome'];
			$dados .= '|';
		};
		echo $dados;
	}
	else
	{
		echo "\nbanco vazio";
	}


?>