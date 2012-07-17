package
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.LoaderInfo;
	
	/**
	* Classe do preloader que carrega o aplicativo principal do jogo.
	* @author Galindo
	*/
	public class Preloader extends Sprite
	{
		// Variáveis utilizadas para carregar o arquivo do jogo
		private var UrlArquivo:String = "Emotigum.swf";
		private var UrlReq:URLRequest;
		private var Carregador:Loader = new Loader();
		private var PctInt:int;
		
		/**
		* Construtor da classe, não recebe parâmetros.
		* @author Galindo
		*/
		public function Preloader()
		{
			// Configura o stage
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			
			// Deixa a barra de carregamento na posição inicial
			Barra.Preenchimento.scaleX = 0;
			ConfiguraEvt(Carregador);
			UrlReq = new URLRequest(UrlArquivo);
			Carregador.load(UrlReq);
		}
		
		/**
		* Configura eventos do carregador.
		* @author Galindo
		*/
		private function ConfiguraEvt(car:Loader):void
		{
			car.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Progresso);
			car.contentLoaderInfo.addEventListener(Event.COMPLETE, Completo);
		}
		
		/**
		* Evento chamado durante o carregamento do arquivo.
		* @author Galindo
		*/
		private function Progresso(e:ProgressEvent):void
		{
			// Altera o tamanho da barra
			Barra.Preenchimento.scaleX = e.bytesLoaded / e.bytesTotal;
			PctInt = Barra.Preenchimento.scaleX * 100;
			TxtPct.text = PctInt + "%";
		}
		
		/**
		* Evento chamado quando o carregamento está completo.
		* @author Galindo
		*/
		private function Completo(e:Event):void
		{
			// Atribui os parâmetros
			(Carregador.content as MovieClip).InitApp(stage);
			addChild(Carregador);
		}
	}
}