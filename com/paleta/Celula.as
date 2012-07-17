package paleta
{
	import flash.display.Sprite;
	
	/**
	* Classe da célula utilizada na paleta de cores.
	* @author Galindo
	*/
	public class Celula extends Sprite
	{
		// Cor correspondente na célula
		private var _cor:uint = 0x000000;
		
		/**
		* Construtor, não recebe parâmetros.
		* @author Galindo
		*/
		public function Celula()
		{
			this.buttonMode = true;
		}
		
		/**
		* Retorna a cor da célula.
		* @author Galindo
		*/
		public function get Cor():uint
		{
			return _cor;
		}
		
		/**
		* Desenha o quadrado da paleta.
		* @author Galindo
		*/
		public function Desenha(cor:uint, larg:Number=10, alt:Number=10):void
		{
			_cor = cor;
			this.graphics.clear();
			this.graphics.beginFill(cor);
			this.graphics.drawRect(0, 0, larg, alt);
		}
	}
}