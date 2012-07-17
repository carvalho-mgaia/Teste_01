package
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.events.Event;
	import paleta.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	* Classe da ferramenta de desenho.
	* @author Galindo
	*/
	public class FerramentaDesenho extends Sprite
	{
		private var _MyStage:Stage;
		private var _AreaDesenho:Sprite;
		private var Graficos:Graphics;
		private var _desenhos:Vector.<Sprite>;
		private var _indiceDesenho:uint;
		private var multiplicadorLinha:Number = 0.1;
		private var AdicionaDesenho:Boolean = false;
		public var _isOpen:Boolean = false;
		public var mascara:Mascara;
		private var paletaDesenho:PaletaDesenho = new PaletaDesenho();
		
		// tamanho dos tracos
		private const TRACO_1:Number = 8;
		private const TRACO_2:Number = 15;
		private const TRACO_3:Number = 40;
		private var GrossuraLinha:Number = TRACO_1;
		
		/**
		* Construtor, inicializa os eventos.
		* @author Galindo
		*/
		public function FerramentaDesenho()
		{
			SetMouseCursor();
			
			BtnUndo.addEventListener(MouseEvent.MOUSE_DOWN, BtnUndoClick);
			BtnUndo.enabled = false;
			
			BtnRedo.addEventListener(MouseEvent.MOUSE_DOWN, BtnRedoClick);
			BtnRedo.enabled = false;
			
			btnTraco1.addEventListener(MouseEvent.CLICK, BtnTraco1Click);
			btnTraco2.addEventListener(MouseEvent.CLICK, BtnTraco2Click);
			btnTraco3.addEventListener(MouseEvent.CLICK, BtnTraco3Click);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, RemovedListener);
			
			paletaDesenho.x = 20;
			paletaDesenho.y = 90;
			addChild(paletaDesenho);
			paletaDesenho.Cria(GeradorDePaletas.PaletaCabelo, 20, 20, 5);
			paletaDesenho.visible = true;
		}
		
		/**
		*
		* @author Carvalho
		*/
		private function RemovedListener(e:Event):void
		{
			_MyStage.removeEventListener(MouseEvent.MOUSE_UP, MouseUp);
			_AreaDesenho.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			
			this.mouseEnabled = false;
			mascara.visible = false;
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
			this.mouseEnabled = value;
			mascara.visible = value;
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function set IndiceDesenho(i:uint):void
		{
			_indiceDesenho = i;
			
			if (IndiceDesenho > 0)
			{
				BtnUndo.alpha = 1;
				BtnUndo.mouseEnabled = true;
				BtnUndo.enabled = true;
			}
			else
			{
				BtnUndo.alpha = 0.2;
				BtnUndo.mouseEnabled = false;
			}
			
			if (IndiceDesenho == Desenhos.length)
			{
				BtnRedo.alpha = 0.2;
				BtnRedo.mouseEnabled = false;
				BtnRedo.enabled = false;
			}
			else
			{
				BtnRedo.alpha = 1;
				BtnRedo.mouseEnabled = true;
			}
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function get IndiceDesenho():uint
		{
			return _indiceDesenho;
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function set AreaDesenho(area:Sprite):void
		{
			_AreaDesenho = area;
			_AreaDesenho.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			_AreaDesenho.addEventListener(MouseEvent.MOUSE_OVER, AreaDesenhoOver);
			_AreaDesenho.addEventListener(MouseEvent.MOUSE_OUT, AreaDesenhoOut);
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function set MyStage(stg:Stage):void
		{
			_MyStage = stg;
			_MyStage.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function set Desenhos(vec:Vector.<Sprite>):void
		{
			_desenhos = vec;
			IndiceDesenho = vec.length;
		}
		
		/**
		*
		* @author Carvalho
		*/
		public function get Desenhos():Vector.<Sprite>
		{
			return _desenhos;
		}
		
		/**
		* Evento de mouse down no AreaDesenho de desenho.
		* @author Galindo
		*/
		private function MouseDown(e:MouseEvent):void
		{
			if (_isOpen)
			{
				AdicionaDesenho = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
				
				// Cria o novo sprite, adiciona no vetor e no 'Quadro'
				var sprNovo:Sprite = new Sprite();
				_AreaDesenho.addChild(sprNovo);
				Desenhos[IndiceDesenho] = sprNovo;
				++IndiceDesenho;
				
				// Prepara o gráfico para ser desenhado pelo mouse
				Graficos = sprNovo.graphics;
				Graficos.moveTo(_AreaDesenho.mouseX - 0.1, _AreaDesenho.mouseY - 0.1);
				
				// Desenha no Quadro
				Graficos.lineStyle(GrossuraLinha * multiplicadorLinha, paletaDesenho.SelectedColor.color);
				Graficos.lineTo(_AreaDesenho.mouseX, _AreaDesenho.mouseY);
			}
		}
		
		/**
		* Evento de mouse up no stage principal.
		* @author Galindo
		*/
		private function MouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
		}
		
		/**
		* Botão que faz a ação de 'Ctrl + Z'
		* @author Galindo
		*/
		private function BtnUndoClick(e:MouseEvent):void
		{
			if (IndiceDesenho > 0)
			{
				Desenhos[IndiceDesenho - 1].visible = false;
				--IndiceDesenho;
				
				if(!IndiceDesenho)
				{
					BtnUndo.enabled = false;
				}
				
				if(IndiceDesenho < Desenhos.length)
				{
					BtnRedo.enabled = true;
				}
			}
		}
		
		/**
		* Botão que faz a ação de 'Ctrl + Y'
		* @author Galindo
		*/
		private function BtnRedoClick(e:MouseEvent):void
		{
			if (IndiceDesenho < Desenhos.length)
			{
				Desenhos[IndiceDesenho].visible = true;
				++IndiceDesenho;
				
				if(IndiceDesenho == Desenhos.length)
				{
					BtnRedo.enabled = false;
				}
				
				if(IndiceDesenho > 0)
				{
					BtnUndo.enabled = true;
				}
			}
		}
		
		/**
		* Evento de movimento do mouse no stage principal.
		* @author Galindo
		*/
		private function MouseMove(e:MouseEvent):void
		{
			// Veririca se o mouse está dentro dos limites do AreaDesenho
			if ((_AreaDesenho.mouseX >= (GrossuraLinha * multiplicadorLinha) && _AreaDesenho.mouseX <= 50 - (GrossuraLinha * multiplicadorLinha))
			&& (_AreaDesenho.mouseY >= (GrossuraLinha * multiplicadorLinha) && _AreaDesenho.mouseY <= 50 - (GrossuraLinha * multiplicadorLinha * 0.5)))
			{
				// Verifica se deve adicionar um desenho ao vetor de desenhos
				if(AdicionaDesenho)
				{
					/*// Cria o novo sprite, adiciona no vetor e no 'Quadro'
					var sprNovo:Sprite = new Sprite();
					_AreaDesenho.addChild(sprNovo);
					Desenhos[IndiceDesenho] = sprNovo;
					++IndiceDesenho;
					
					// Prepara o gráfico para ser desenhado pelo mouse
					Graficos = sprNovo.graphics;*/
					Graficos.moveTo(_AreaDesenho.mouseX, _AreaDesenho.mouseY);
					
					// Altera a flag, para não acrescentar mais desenhos
					AdicionaDesenho = false;
				}
				
				// Desenha no Quadro
				Graficos.lineStyle(GrossuraLinha * multiplicadorLinha, paletaDesenho.SelectedColor.color);
				Graficos.lineTo(_AreaDesenho.mouseX, _AreaDesenho.mouseY);
				
			}
		}
		
		/**
		* Transforma o cursor do mouse no ícone do lápis
		* @author Carvalho
		*/
		private function SetMouseCursor():void
		{
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(3,28);
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>();
			bitmapDatas[0] = new PencilCursor();
			cursorData.data	 = bitmapDatas;
			Mouse.registerCursor("myCursor", cursorData);
		}
		
		/**
		*
		* @author Carvalho
		*/
		private function BtnTraco1Click(e:MouseEvent):void
		{
			GrossuraLinha = TRACO_1;
		}
		
		/**
		*
		* @author Carvalho
		*/
		private function BtnTraco2Click(e:MouseEvent):void
		{
			GrossuraLinha = TRACO_2;
		}
		
		/**
		*
		* @author Carvalho
		*/
		private function BtnTraco3Click(e:MouseEvent):void
		{
			GrossuraLinha = TRACO_3;
		}
		
		/**
		* Listener do mouse sobre a area de desenho
		* @author Carvalho
		*/
		private function AreaDesenhoOver(e:MouseEvent):void
		{
			Mouse.cursor = "myCursor";
		}
		
		/**
		* Listener de quando o mouse sai da área de desenho
		* @author Carvalho
		*/
		private function AreaDesenhoOut(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
}
