package  {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	
	public class PecaMosaico extends MovieClip {
		
		private var CarregadorImg:Loader = new Loader();
		
		
		public function PecaMosaico(imgurl:String,nome:String) {
			// Evento do Carregador de Imagens
			CarregadorImg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ImgErro);
			CarregadorImg.contentLoaderInfo.addEventListener(Event.COMPLETE, ImgCompleto);
			
			CarregaImg(imgurl);
			
			txtNome.text = nome;
		}
		
		/**
		* Função utilizada para carregar a imagem dentro desse avatar.
		* @author Galindo
		*/
		public function CarregaImg(url:String):void
		{
			//if(tmpAvatar != null)
			//{
				AnimCarregador.visible = true;
			//}
			CarregadorImg.load(new URLRequest(unescape(url)));
		}
		
		/**
		* Evento chamado ao completar o carregamento da imagem
		* @author Galindo
		*/
		private function ImgCompleto(e:Event):void
		{
			CarregadorImg.x = PainelBranco.x + 1;
			CarregadorImg.y = PainelBranco.y + 1;
			addChild(CarregadorImg);
			
			AnimCarregador.visible = false;
		}
		
		/**
		* Quando ocorre um erro no carregamento da imagem, abre um avatar padrão.
		* @author Galindo
		*/
		private function ImgErro(e:IOErrorEvent):void
		{			
			trace("Erro no carregamento de imagem!");
		}
	}
	
}
