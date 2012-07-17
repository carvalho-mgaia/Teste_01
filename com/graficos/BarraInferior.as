package graficos
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.xml.*;
	import flash.filters.GlowFilter;
	
	/**
	* Classe da barra inferior, que contém os avatares dos seus parceiros no game.
	* @author Galindo
	*/
	public class BarraInferior extends MovieClip
	{
		private var Contorno:GlowFilter = new GlowFilter(0xFFF200, 1, 10, 10, 3, 3);
		private const QTD_VISUALIZACAO:uint = 5;
		private var QtdAvatares:uint = 0;
		private var Avatares:Vector.<Avatar> = new Vector.<Avatar>();
		private var Indice:uint = 0;
		private var ContainerAvatares:Sprite = new Sprite();
		private var Dist:Number = 430 / (QTD_VISUALIZACAO - 1);
		private var Espacamento:Number = 20;
		private var PosY:Number = -145;
		private var PosX:Number = -260;
		private var barraLoading:MovieClip;
		private var DadosXml:XML;
		
		private const ALPHA_ATIVADO:Number = 1.0;
		private const ALPHA_DESATIVADO:Number = 0.3;
		
		/**
		* Construtor, não recebe parâmetros, pois deve ser colado no Stage.
		* @author Galindo
		*/
		public function BarraInferior():void
		{
			// Chamada para desabilitar os botões
			CriaAvatares(null);
			// Adiciona container no stage
			addChild(ContainerAvatares);
			// Adiciona eventos nos botões
			SetaEsq.addEventListener(MouseEvent.CLICK, SetaEsq_Md);
			SetaDir.addEventListener(MouseEvent.CLICK, SetaDir_Md);
			SetaEsq.tabEnabled = false;
			SetaDir.tabEnabled = false;
			// Adicionando loading
			barraLoading = new BarraCinza();
			barraLoading.alpha = 0.7;
			addChild(barraLoading);
		}
		
		/**
		* Cria os avatares de acordo com a quantidade.
		* @author Galindo
		*/
		public function CriaAvatares(lista:Array=null):void
		{
			// Remove todos os avatares antes, com a quantidade antiga
			for(var i:uint = 0; i < QtdAvatares; ++i)
			{
				ContainerAvatares.removeChild(Avatares[i]);
			}
			
			if(lista != null)
			{
				// Reseta a define as variáveis
				Indice = 0;
				QtdAvatares = lista.length;
				Avatares = new Vector.<Avatar>();
				var qtdErro:uint = 0;
				
				// Remove a barra de carregamento
				if(QtdAvatares > 0)
				{
					if(this.contains(barraLoading))
					{
						removeChild(barraLoading);
					}
				}
				
				// Criando os Avatares
				for(i = 0; i < QtdAvatares; ++i)
				{
					var tmpAvatar:Avatar = new Avatar(this);
					tmpAvatar.y = PosY;
					tmpAvatar.x = PosX + (Dist * i);
					tmpAvatar.scaleX = tmpAvatar.scaleY = 1;
					
					tmpAvatar.CarregaImgURL(lista[i].imgLink);
					tmpAvatar.Nome = lista[i].nome;
					
					if(i < (Indice + QTD_VISUALIZACAO))
					{
						tmpAvatar.visible = true;
					}
					else
					{
						tmpAvatar.visible = false;
					}
					
					Avatares[i] = tmpAvatar;
					ContainerAvatares.addChild(tmpAvatar);
				}
				
				QtdAvatares -= qtdErro;
			}
			
			// Configura as setas de Esq/Dir
			ConfigSetas();
		}
		
		/**
		* Configura qual a função dos avatares ao serem clicados.
		* @author Galindo
		*/
		public function ConfigAvatares(habilitado:Boolean, callBack:Function=null):void
		{
			for(var i:uint = 0; i < QtdAvatares; ++i)
			{
				if(habilitado)
				{
					Avatares[i].Enabled = true;
					Avatares[i].CallBack = callBack;
				}
				else
				{
					Avatares[i].Enabled = false;
				}
			}
		}
		
		/**
		* Aplica o glow amarelo em torno da barra azul.
		* @author Galindo
		*/
//		public function AplicaBrilho():void
//		{
//			this.Fundo.filters = [Contorno];
//		}
		
		/**
		* Clique na seta esquerda.
		* @author Galindo
		*/
		private function SetaEsq_Md(e:MouseEvent):void
		{
			var IndiceFuturo:int = Indice - 1;
			if((IndiceFuturo + QTD_VISUALIZACAO) >= 0)
			{
				--Indice;
				PosicionaAvatares(1);
				ConfigSetas();
			}
		}
		
		/**
		* Clique na seta direita.
		* @author Galindo
		*/
		private function SetaDir_Md(e:MouseEvent):void
		{
			var IndiceFuturo:int = Indice + 1;
			if((IndiceFuturo + QTD_VISUALIZACAO) <= QtdAvatares)
			{
				++Indice;
				PosicionaAvatares(-1);
				ConfigSetas();
			}
		}
		
		/**
		* Posicionamento dos avatares
		* @author Galindo
		*/
		private function PosicionaAvatares(dir:int):void
		{
			var k:int;
			for(var i:uint = 0; i < QtdAvatares; ++i)
			{
				k = i + Indice;
				if(dir == 1)
				{
					Avatares[i].x += Dist;
				}
				else if(dir == -1)
				{
					Avatares[i].x -= Dist;
				}
				
				if((i >= Indice) && (i < (Indice + QTD_VISUALIZACAO)))
				{
					Avatares[i].visible = true;
				}
				else
				{
					Avatares[i].visible = false;
				}
			}
		}
		
		/**
		* Habilita/Desabilita setas
		* @author Galindo
		*/
		private function ConfigSetas():void
		{
			if(QtdAvatares <= QTD_VISUALIZACAO)
			{
				// Desabilita as duas
				SetaEsq.enabled = SetaEsq.mouseEnabled = false;
				SetaEsq.alpha = ALPHA_DESATIVADO;
				SetaDir.enabled = SetaDir.mouseEnabled = false;
				SetaDir.alpha = ALPHA_DESATIVADO;
			}
			else
			{
				// Habilita as duas, a princípio
				SetaEsq.enabled = SetaEsq.mouseEnabled = true;
				SetaEsq.alpha = ALPHA_ATIVADO;
				SetaDir.enabled = SetaDir.mouseEnabled = true;
				SetaDir.alpha = ALPHA_ATIVADO;
				
				// Analisa o índice
				if(Indice == 0)
				{
					// Desabilita Esquerda, habilita direita
					SetaEsq.enabled = SetaEsq.mouseEnabled = false;
					SetaEsq.alpha = ALPHA_DESATIVADO;
					SetaDir.enabled = SetaDir.mouseEnabled = true;
					SetaDir.alpha = ALPHA_ATIVADO;
				}
				else if(Indice == QtdAvatares - QTD_VISUALIZACAO)
				{
					// Desabilita Direita, habilita esquerda
					SetaEsq.enabled = SetaEsq.mouseEnabled = true;
					SetaEsq.alpha = ALPHA_ATIVADO;
					SetaDir.enabled = SetaDir.mouseEnabled = false;
					SetaDir.alpha = ALPHA_DESATIVADO;
				}
				else
				{
					// Habilita as duas
					SetaEsq.enabled = SetaEsq.mouseEnabled = true;
					SetaEsq.alpha = ALPHA_ATIVADO;
					SetaDir.enabled = SetaDir.mouseEnabled = true;
					SetaDir.alpha = ALPHA_ATIVADO;
				}
			}
		}
	}
}
