package BoxAcessorios
{
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import flash.events.MouseEvent;
	import fl.transitions.easing.Regular;
	import flash.geom.Point;
	
	/**
	* Caixa dos acessórios arrastáveis para o Emotigum, com paginação.
	* @author Galindo
	*/
	public class BoxAcessorio extends MovieClip
	{
		// Vetor de tweens das caixas
		private var VecTweensCaixas:Vector.<Tween> = new Vector.<Tween>();
		// Vetor de tweens dos acessórios
		private var VecTweensAcessorios:Vector.<Tween> = new Vector.<Tween>();
		// Indice da pagina
		private var IndicePagina:int = 0;
		// Quantidade de páginas
		private var QtdPaginas:uint = 2;
		
		// Transparências
		private var ALPHA_ATIVADO:Number = 1.0;
		private var ALPHA_DESATIVADO:Number = 0.6;
		
		// Distancia da troca de página
		private var Distancia:Number = 170.55;
		// Quantidade de caixas
		private var QtdCaixas:uint = 17;
		
		// Posicoes originais das caixas
		private var PosOriginaisCaixas:Vector.<Number> = new Vector.<Number>();
		// Lista dos elementos
		private var ArrAcessorios:Array = [
			"oculos1", "oculos2", "oculos3", "oculos4",
			"cabelo1", "cabelo2", "cabelo3", "cabelo4",
			"cabelo5", "cabelo6", "cabelo7", "extra1",
			"oculos5", "cabelo8", "cabelo9", "cabelo10",
			"cabelo11"
		];
		// Posicões originais dos acessórios
		private var PosOriginaisAcessorios:Vector.<Object> = new Vector.<Object>();
		
		/**
		* Construtor, não recebe parâmetros.
		* @author Galindo
		*/
		public function BoxAcessorio()
		{
			BtnEsq.tabEnabled = false;
			BtnDir.tabEnabled = false;
			
			BtnEsq.addEventListener(MouseEvent.MOUSE_DOWN, BtnEsq_Md);
			BtnDir.addEventListener(MouseEvent.MOUSE_DOWN, BtnDir_Md);
			
			ConfigBotoes();
			
			// Preservando a posição original das caixas
			for(var i:uint = 0; i < ArrAcessorios.length; ++i)
			{
				PosOriginaisCaixas[i] = this["caixa" + i].x;
			}
			// Preservando a posição original dos acessórios
			for(i = 0; i < ArrAcessorios.length; ++i)
			{
				PosOriginaisAcessorios[i] = {
					mc: this[ArrAcessorios[i]],
					posx: this[ArrAcessorios[i]].x
				};
			}
		}
		
		/**
		* Configura os botões.
		* @author Galindo
		*/
		private function ConfigBotoes():void
		{
			BtnEsq.mouseEnabled = true;
			BtnEsq.enabled = true;
			BtnEsq.alpha = ALPHA_ATIVADO;
			
			BtnDir.mouseEnabled = true;
			BtnDir.enabled = true;
			BtnDir.alpha = ALPHA_ATIVADO;
			
			if(IndicePagina == 0)
			{
				BtnEsq.mouseEnabled = false;
				BtnEsq.enabled = false;
				BtnEsq.alpha = ALPHA_DESATIVADO;
			}
			if(IndicePagina == QtdPaginas - 1)
			{
				BtnDir.mouseEnabled = false;
				BtnDir.enabled = false;
				BtnDir.alpha = ALPHA_DESATIVADO;
			}
		}
		
		/**
		* Evento de mouse down no botão da esquerda.
		* @author Galindo
		*/
		private function BtnEsq_Md(e:MouseEvent):void
		{
			--IndicePagina;
			if(IndicePagina < 0)
			{
				IndicePagina = 0;
			}
			ConfigBotoes();
			MudaPagina();
		}
		
		/**
		* Evento de mouse down no botão da direita.
		* @author Galindo
		*/
		private function BtnDir_Md(e:MouseEvent):void
		{
			IndicePagina = ++IndicePagina % QtdPaginas;
			ConfigBotoes();
			MudaPagina();
		}
		
		/**
		* Muda a página, movimentado todos as caixas/acessórios.
		* @author Galindo
		*/
		private function MudaPagina():void
		{
			// Movimenta as caixas
			for(var i:uint = 0; i < ArrAcessorios.length; ++i)
			{
				VecTweensCaixas[i] = new Tween(
					this["caixa"+i], "x",
					Regular.easeIn,
					this["caixa"+i].x, PosOriginaisCaixas[i] - IndicePagina * Distancia,
					0.4, true
				);
			}
			for(i = 0; i < PosOriginaisAcessorios.length; ++i)
			{
				var newposx:Number = PosOriginaisAcessorios[i].posx - IndicePagina * Distancia;
				
				VecTweensAcessorios[i] = new Tween(
					PosOriginaisAcessorios[i].mc, "x",
					Regular.easeIn,
					PosOriginaisAcessorios[i].mc.x, newposx,
					0.4, true
				);
				
				PosOriginaisAcessorios[i].mc.PosicaoOriginal = new Point(
					newposx,
					PosOriginaisAcessorios[i].mc.PosicaoOriginal.y
				);
			}
		}
	}
}