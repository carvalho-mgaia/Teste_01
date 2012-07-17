package BoxAcessorios
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	public class DragableItem extends MovieClip
	{
		private var dragTarget:Sprite;
		public var PosicaoOriginal:Point = new Point();
		private var Pai:DisplayObjectContainer;
		private var auxItem:AcessorioDrag;
		private var tooltip:Tooltip = new Tooltip();
		
		public function DragableItem() 
		{
			this.buttonMode = true;
			this.mouseEnabled = true;
			
			Pai = this.parent;
			
			PosicaoOriginal.x = this.x;
			PosicaoOriginal.y = this.y;
			//this.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			box.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
		}
		
		/**
		* Exibe uma dica ao posicionar o mouse sobre o item
		* @author Carvalho/Galindo
		*/
		private function MouseOver(e:MouseEvent):void
		{
			stage.addChild(tooltip);
			tooltip.x = stage.mouseX - 5;
			tooltip.y = stage.mouseY - 5;
			var myTween:Tween = new Tween(tooltip, "alpha", Regular.easeIn, 0, 1, 0.5, true);
			box.addEventListener(MouseEvent.MOUSE_OUT, MouseOut);
		}
		
		/**
		* Remove a dica quando retira o mouse de cima
		* @author Carvalho/Galindo
		*/
		private function MouseOut(e:MouseEvent):void
		{
			stage.removeChild(tooltip);
			box.removeEventListener(MouseEvent.MOUSE_OUT, MouseOut);
		}
		
		public function VoltarPosicao():void
		{
			this.x = PosicaoOriginal.x;
			this.y = PosicaoOriginal.y;
			this.scaleX = 0.4;
			this.scaleY = 0.4;
		}
		
		private function ItemMouseDown(e:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, StgMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
		}
		
		/**
		*
		* @author Carvalho/Galindo
		*/
		private function MouseDown(e:MouseEvent):void
		{
			var i:uint;
			
			for (i = 1; i <= 5; ++i)
			{
				if (this is (getDefinitionByName("Oculos"+i) as Class))
				{
					auxItem = new Oculos();
					auxItem.scaleX = auxItem.scaleY = 1.7;
					auxItem.gotoAndStop(i);
					auxItem.FrameChanged();
					auxItem.addEventListener(MouseEvent.MOUSE_DOWN, ItemMouseDown);
					//CallbackAcessorios(Boneco.oculos);
				}
			}
			for (i = 1; i <= 11; ++i)
			{
				if (this is (getDefinitionByName("Cabelo"+i) as Class))
				{
					auxItem = new AcessorioCabelo();
					auxItem.scaleX = auxItem.scaleY = 2.78;
					auxItem.gotoAndStop(i);
					auxItem.FrameChanged();
					auxItem.addEventListener(MouseEvent.MOUSE_DOWN, ItemMouseDown);
					//CallbackAcessorios(Boneco.acessorio);
				}
			}
			for (i = 1; i <= 1; ++i)
			{
				if (this is (getDefinitionByName("Extra"+i) as Class))
				{
					auxItem = new ExtraTribo();
					auxItem.scaleX = auxItem.scaleY = 2;
					auxItem.gotoAndStop(i);
					auxItem.FrameChanged();
					auxItem.addEventListener(MouseEvent.MOUSE_DOWN, ItemMouseDown);
				}
			}
			
			this.stage.addChild(auxItem);
			auxItem.startDrag(true);
			
			PosicionaMouse();
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, StgMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
		}
		
		private function StgMouseMove(e:MouseEvent):void
		{
			PosicionaMouse();
			e.updateAfterEvent();
		}
		
		/**
		* 
		* @author Galindo
		*/
		private function StgMouseUp(e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, StgMouseMove);			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
			
			auxItem.stopDrag();
			
			trace("auxItem",auxItem.x,auxItem.y);
			
			if ((auxItem.x > Constantes.InfoBoneco.x) && (auxItem.x < Constantes.InfoBoneco.x + Constantes.InfoBoneco.width) &&
				(auxItem.y > Constantes.InfoBoneco.y) && (auxItem.y < Constantes.InfoBoneco.y + Constantes.InfoBoneco.height))
				{
					trace("dentro");
				}
				else
				{
					trace("fora");
					auxItem.parent.removeChild(auxItem);
				}
		}
		
		/**
		*
		* @author Galindo
		*/
		private function PosicionaMouse():void
		{
			auxItem.x = Math.floor(this.stage.mouseX);
			auxItem.y = Math.floor(this.stage.mouseY);
		}
		
		/**
		* 
		* @author Galindo
		*/
		public function set Position(point:Point):void
		{
			this.x = point.x;
			this.y = point.y;
		}
		
		/**
		* 
		* @author Galindo
		*/
		public function get Position():Point
		{
			return new Point(this.x, this.y);
		}
	}
}