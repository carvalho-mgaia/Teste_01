package graficos
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import flash.filters.GlowFilter;
	import flash.events.IOErrorEvent;
	
	/**
	* Classe do quadr de avatar, que contém a foto do parceiro, pontos e amigos.
	* @author Galindo
	*/
	public class Avatar extends MovieClip
	{
		private var CarregadorImg:Loader = new Loader();
		private var Contorno:GlowFilter = new GlowFilter(0xFFFF33, 0.9, 8, 8, 3, 3);
		private var tmpAvatar:MovieClip;
		public var CallBack:Function = null;
		private var _enabled:Boolean = false;
		private var parentBarra:BarraInferior;
		
		private var _nome:String = "", _sobrenome:String = "";
		private var _pontos:Number = 0;
		private var _qtdAmigos:uint = 0;
		private var _id:String = "";
		
		private var ImgPosX:uint = 15;
		private var ImgPosY:uint = 8;
		
		/**
		* Construtor, não recebe parâmetros. Adiciona os eventos para o carregador de imagem.
		* @author Galindo
		*/
		public function Avatar(barra:BarraInferior):void
		{
			parentBarra = barra;
			this.tabEnabled = false;
			
			// Evento do Carregador de Imagens
			CarregadorImg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ImgErro);
			CarregadorImg.contentLoaderInfo.addEventListener(Event.COMPLETE, ImgCompleto);
			CarregadorImg.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ImgProgresso);
		}
		
		/**
		* Retorna se o avatar está disponível para ser clicado ou não.
		* @author Galindo
		*/
		public function get Enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		* Seta a propriedade para o avatar ser clicável ou não.
		* @author Galindo
		*/
		public function set Enabled(bool:Boolean):void
		{
			_enabled = bool;
			if(bool)
			{
				this.buttonMode = this.mouseEnabled = true;
				if(!this.willTrigger(MouseEvent.CLICK))
				{
					// Adiciona
					this.addEventListener(MouseEvent.CLICK, Click);
					this.addEventListener(MouseEvent.MOUSE_OVER, Mover);
					this.addEventListener(MouseEvent.MOUSE_OUT, Mout);
				}
			}
			else
			{
				// Também remove o contorno (filtro) do avatar
				this.filters = [];
				this.buttonMode = this.mouseEnabled = false;
				if(this.willTrigger(MouseEvent.CLICK))
				{
					// Remove
					this.removeEventListener(MouseEvent.CLICK, Click);
					this.removeEventListener(MouseEvent.MOUSE_OVER, Mover);
					this.removeEventListener(MouseEvent.MOUSE_OUT, Mout);
				}
			}
		}
		
		/**
		* Evento chamado quando o avatar é clicado.
		* @author Galindo
		*/
		private function Click(e:MouseEvent):void
		{
			if((CallBack != null) && Enabled)
			{
				CallBack(this);
			}
		}
		
		/**
		* Evento chamado quando o mouse está sobre esse avatar.
		* @author Galindo
		*/
		private function Mover(e:MouseEvent):void
		{
			if(parentBarra["Seta"].visible)
			{
				parentBarra["Seta"].visible = false;
				parentBarra["Fundo"].filters = [];
			}
			this.filters = [Contorno];
		}
		
		/**
		* Evento chamado quando o mouse está fora dos limites desse avatar.
		* @author Galindo
		*/
		private function Mout(e:MouseEvent):void
		{
			this.filters = [];
		}
		
		/**
		* Função utilizada para carregar a imagem dentro desse avatar.
		* @author Galindo
		*/
		public function CarregaImgURL(urlReq:URLRequest):void
		{
			if(tmpAvatar != null)
			{
				removeChild(tmpAvatar);
				AnimCarregador.visible = true;
			}
			CarregadorImg.load(urlReq);
		}
		
		/**
		* Evento chamado ao completar o carregamento da imagem
		* @author Galindo
		*/
		private function ImgCompleto(e:Event):void
		{
			CarregadorImg.x = PainelBranco.x + ImgPosX;
			CarregadorImg.y = PainelBranco.y + ImgPosY;
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
		
		/**
		* Chamado enquanto o arquivo de imagem é carregado.
		* @author Galindo
		*/
		private function ImgProgresso(e:ProgressEvent):void
		{
			
		}
		
		/**
		* Atribui o nome do jogador.
		* @author Galindo
		*/
		public function set Nome(str:String):void
		{
			_nome = str;
			txtNome.text = str;
		}
		
		/**
		* Retorna o nome do jogador.
		* @author Galindo
		*/
		public function get Nome():String
		{
			return _nome;
		}
		
		/**
		* Atribui o sobrenome do jogador.
		* @author Galindo
		*/
		public function set Sobrenome(str:String):void
		{
			_sobrenome = str;
		}
		
		/**
		* Retorna o sobrenome do jogador.
		* @author Galindo
		*/
		public function get Sobrenome():String
		{
			return _sobrenome;
		}
		
		/**
		* Retorna a quantidade de pontos que o jogador possui.
		* @author Galindo
		*/
		public function get Pontos():Number
		{
			return _pontos;
		}
		
		/**
		* Retorna a quantidade de amigos que o jogador possui no jogo.
		* @author Galindo
		*/
		public function get QtdAmigos():uint
		{
			return _qtdAmigos;
		}
		
		/**
		* Define a ID do usuário no Facebook.
		* @author Galindo
		*/
		public function set ID(id:String):void
		{
			_id = id;
		}
		
		/**
		* Retorna a ID do usuário no Facebook.
		* @author Galindo
		*/
		public function get ID():String
		{
			return _id;
		}
	}
}
