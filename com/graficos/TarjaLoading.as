package graficos
{
	import flash.display.Sprite;
	import com.facebook.graph.controls.Distractor;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.MouseEvent;
	
	/**
	* Classe que cria uma tarja preta por cima do aplicativo, para indicar que está fazendo
	*  uma requisição na Web.
	* OBS.: Deve ser incluída dentro dos eventos de botão (mouse event) nas chamadas a Api
	*  do FB, e removida com o callback (sucesso/fail).
	* @author Galindo
	*/
	public class TarjaLoading extends Sprite
	{
		// Gráfico do Facebook
		private var distractor:Distractor;
		// Cor da tarja
		private var Cor:uint = 0x000000;
		// Nível de transparência
		private var Alpha:Number = 0.4;
		// Texto
		private var Tf:TextField;
		// Formatação do texto
		private var Formatacao:TextFormat;
		// Fonte, tamanho da letra e cor do texto
		private var Fonte:String = "_sans";
		private var Tamanho:Number = 11;
		private var CorTexto:uint = 0xFFFFFF;
		
		// Largura do App
		private const Largura:Number = 760;
		// Altura do App
		private const Altura:Number = 600;
		
		/**
		* Construtor, não recebe parâmetros.
		* @author Galindo
		*/
		public function TarjaLoading():void
		{
			distractor = new Distractor();
			distractor.scaleX *= 1.6;
			distractor.scaleY = distractor.scaleX;
			distractor.x = (Largura / 2) - distractor.width - 30;
			distractor.y = (Altura / 2) - 20;
			
			// Evento do botão 'OK' na popup interna
			PopUpInterna.BtnOk.tabEnabled = false;
			PopUpInterna.BtnOk.addEventListener(MouseEvent.CLICK, PopUpInterna_Click);
		}
		
		/**
		* Configura os gráficos e adiciona no stage.
		* @author Galindo
		*/
		private var AjusteX:Number = 192;
		private var AjusteY:Number = 40;
		public function Adiciona(disp:DisplayObjectContainer, texto:String=""):void
		{
			// Adiciona o gráfico do Facebbok e atribui o texto
			addChild(distractor);
			
			// Adiciona e apaga a janela de PopUp
			PopUpInterna.visible = false;
			
			// Cria o texto para a legenda
			Tf = new TextField();
			Formatacao = new TextFormat(Fonte, Tamanho, CorTexto);
			Formatacao.align = TextFormatAlign.LEFT;
			
			// Formata o texto
			Tf.selectable = false;
			Tf.defaultTextFormat = Formatacao;
			Tf.text = texto;
			Tf.width = Tf.textWidth + 10;
			Tf.x = (distractor.x + AjusteX) - Tf.width/2;
			Tf.y = distractor.y + AjusteY;
			addChild(Tf);
			
			// Desenha fundo preto
			graphics.beginFill(Cor, Alpha);
			graphics.drawRect(0, 0, Largura, Altura);
			
			// Adiciona no Stage
			disp.addChild(this);
		}
		
		/**
		* Remove o gráfico.
		* @author Galindo
		*/
		public function Remove():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			// Limpa o desenho da tarja preta
			graphics.clear();
		}
		
		/**
		* Mostra janela de aviso.
		* @author Galindo
		*/
		public function ShowPopUp(txt:String=""):void
		{
			PopUpInterna.visible = true;
			PopUpInterna.text = txt;
			
			if(contains(distractor))
			{
				removeChild(distractor);
			}
			if(contains(Tf))
			{
				removeChild(Tf);
			}
		}
		
		/**
		* Evento de clique no botão 'OK'
		* @author Galindo
		*/
		private function PopUpInterna_Click(e:MouseEvent):void
		{
			Remove();
		}
	}
}
