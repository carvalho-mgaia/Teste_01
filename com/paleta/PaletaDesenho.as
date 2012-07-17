package paleta
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.filters.DropShadowFilter;
	
	/**
	* Classe que cria uma paleta de cores.
	* @author Galindo
	*/
	public class PaletaDesenho extends Sprite
	{
		// Variáveis que configuram as cores
		private var Largura:Number = 20;
		private var Altura:Number = 20;
		private var QtdLinha:uint = 10;
		private var Espacamento:Number = 3;
		private var QtdCores:uint;
		private var Cores:Array;
		private var colorTransform:ColorTransform = new ColorTransform();
		
		// Vetor de sprites contendo as cores da paleta
		private var Celulas:Vector.<Celula> = new Vector.<Celula>();
		
		// Callback do clique em cada célula
		private var _alvo:Sprite = null;
		
		// Filtro de sombra das células da paleta
		private var Sombra:DropShadowFilter = new DropShadowFilter(
			1, 45, 0x333333, 0.5,
			2, 2, 1, 3
		);
		
		// Sprite de fundo da paleta
		private var Fundo:Sprite = new Sprite();
		// Borda do background
		private var Borda:Number = 4;
		// Cor do fundo
		private var CorFundo:uint = 0xFFFFFF;
		// Alpha do fundo
		private var AlphaFundo:Number = 1;
		
		
		/**
		* Construtor, recebe parâmetros.
		* @author Galindo
		*/
		public function PaletaDesenho()
		{
			//addChild(Fundo);
		}
		
		public function get SelectedColor():ColorTransform
		{
			return colorTransform;
		}
		
		/**
		* Cria uma paleta de cores.
		* @author Galindo
		*/
		public function Cria(cores:Array, larg:Number=20, alt:Number=20, qtdLinha:uint=10):void
		{
			Apaga();
			
			Cores = cores;
			Largura = larg;
			Altura = alt;
			QtdLinha = qtdLinha;
			
			var posx:Number = 0;
			var posy:Number = 0;
			
			var tmpCelula:Celula;
			QtdCores = cores.length;
			var j:uint = 0;
			var cont:uint = 0;
			for(var i:uint = 0; i < QtdCores; ++i)
			{
				// Cria nova célula
				tmpCelula = new Celula();
				// Preenche com a cor
				tmpCelula.Desenha(cores[i], Largura, Altura);
				// Posiciona
				tmpCelula.x = posx;
				tmpCelula.y = posy;
				// Adiciona na paleta
				this.addChild(tmpCelula);
				// Adiciona no vetor de células
				Celulas.push(tmpCelula);
				// Adiciona o filtro
				tmpCelula.filters = [Sombra];
				
				// Adiciona o evento
				tmpCelula.addEventListener(MouseEvent.MOUSE_DOWN, Celula_Mdown);
				
				// Ajusta a posição seguinte
				posx += Largura + Espacamento;
				// Incremento
				++cont;
				// Quando chegar ao limite da largura
				if(cont == QtdLinha)
				{
					// Pula uma linha para baixo
					posy += Altura + Espacamento;
					// Zera a posição x
					posx = 0;
					// Zera o contador
					cont = 0;
				}
			}//for i
		}
		
		
		/**
		* Evento de mouse down na célula.
		* @author Galindo
		*/
		private function Celula_Mdown(e:MouseEvent):void
		{
			colorTransform.color = (e.target as Celula).Cor;
		}
		
		/**
		* Apaga as células da paleta.
		* @author Galindo
		*/
		public function Apaga():void
		{
			for(;Celulas.length;)
			{
				removeChild(Celulas.pop());
			}
		}
	}
}
