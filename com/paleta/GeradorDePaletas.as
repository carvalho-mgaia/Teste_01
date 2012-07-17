package paleta
{
	/**
	* Classe contendo as paletas de cores do Emotigum.
	* @author Galindo
	*/
	public class GeradorDePaletas
	{
		// Cores dos olhos
		private static const PRETO:uint = 0x231F20;
		private static const BRANCO:uint = 0xFFFFFF;
		private static const CASTANHO_ESCURO:uint = 0x502B0F;
		private static const CASTANHO_CLARO:uint = 0xAD6C28;
		private static const AZUL:uint = 0x60B4E5;
		private static const VERDE_CLARO:uint = 0x68BE5A;
		
		
		// Cores do corpo
		private static const ROSA_ESCURO:uint = 0xCE1789;
		private static const ROSA:uint = 0xF7AFC3;
		private static const AZUL_TURQUESA:uint = 0x2AABE4;
		private static const CINZA:uint = 0xA3A6A9;
		private static const AMARELO:uint = 0xFFDD00;
		private static const PRETO_CORPO:uint = 0x222222;
		
		// Cores do Cabelo
		private static const DOURADO:uint = 0xECD843;
		private static const RUIVO:uint = 0xD12627;
		private static const ROSINHA:uint = 0xE79CC4;
		private static const ROXO:uint = 0x7C5EA8;
		private static const VERDE_MUSGO:uint = 0x87C440;
		
		// Array contendo a paleta de cores dos olhos
		public static function get PaletaOlhos():Array
		{
			return [
				BRANCO,
				PRETO,
				CASTANHO_ESCURO,
				CASTANHO_CLARO,
				AZUL,
				VERDE_CLARO
			];
		}
		
		// Array contendo a paleta de cores do corpo
		public static function get PaletaCorpo():Array
		{
			return [
				ROSA_ESCURO,
				ROSA,
				AZUL_TURQUESA,
				CINZA,
				AMARELO,
				PRETO_CORPO,
				BRANCO
			];
		}
		
		// Array contendo a paleta de cores do corpo
		public static function get PaletaCabelo():Array
		{
			return [
				PRETO,
				CASTANHO_ESCURO,
				CASTANHO_CLARO,
				DOURADO,
				RUIVO,
				BRANCO,
				ROSINHA,
				ROXO,
				AZUL,
				VERDE_MUSGO
			];
		}
	}
}