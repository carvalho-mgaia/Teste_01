package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	* Classe do boneco que será customizado.
	* @author Carvalho
	*/
	public class MCBoneco extends MovieClip 
	{
		// Vetor dos desenhos que serão montados pela Ferramenta de Desenho
		public var Desenhos:Vector.<Sprite> = new Vector.<Sprite>();
		
		/**
		* Construtor, não recebe parâmetros.
		* @author Carvalho
		*/
		public function MCBoneco()
		{
			addChild(Borda);
		}
	}
}