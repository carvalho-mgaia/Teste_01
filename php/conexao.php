<?php
// Constantes com os dados do db.
define('DB_NOME', 'cityrain_emotigum-me');
define('DB_USUARIO', 'cityrain_admin');
define('DB_SENHA', 'mgaia0807');
define('DB_HOST', 'localhost');

// Conecta ao MySQL.
$conexao = mysql_connect(DB_HOST, DB_USUARIO, DB_SENHA) or die ('Erro ao conectar ao MySQL: ' . mysql_error());

// Conectar ao db 'pagseguro'.
$conexaoDb = mysql_select_db(DB_NOME, $conexao) or die ('Erro ao conectar a base de dados: ' . mysql_error());
?>