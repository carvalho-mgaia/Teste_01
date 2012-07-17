package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class AcessorioDrag extends AvatarPart
	{
		public function AcessorioDrag()
		{
			if(colorivelInterno)
			{
				Colorivel = colorivelInterno;
			}
			
			this.buttonMode = true;
			this.mouseEnabled = true;
			
			PosicaoOriginal.x = this.x;
			PosicaoOriginal.y = this.y;

			//this.addEventListener(MouseEvent.MOUSE_DOWN, Drag);
		}
		
		/**
		* Retorna o clip que é colorível
		* @author Galindo
		*/
		override public function get Colorivel():MovieClip
		{
			return colorivelInterno;
		}
		
		/**
		* Define o clip que será colorível
		* @author Galindo
		*/
		override public function set Colorivel(mc:MovieClip):void
		{
			colorivelInterno = mc;
		}
		
		/*
		* Quando muda de frame, checa se há colorível
		* @Author Carvalho
		*/
		public function FrameChanged():void
		{
			if(colorivelInterno)
			{
				Colorivel = colorivelInterno;
			}
		}
		
		private function Drag(e:MouseEvent):void
		{
			//this.startDrag();
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
		}
		
		private function MouseMove(e:MouseEvent):void
		{
			//trace(this, this.name);
			this.startDrag();
			e.updateAfterEvent();
		}
		
		private function MouseUp(e:MouseEvent):void
		{
			var margem:uint = 10; // Margem de pixels utilizada na soma para facilitar a remoção do acessório
			var auxX:int = this.x + this.parent.x + (this.width/2);
			var auxY:int = this.y + this.parent.y + (this.height/2);
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, MouseUp);
			
			this.stopDrag();
			
			if ((auxX - margem < this.parent.x) || (auxX + margem > this.parent.x + this.parent.width) ||
				(auxY - margem < this.parent.y) || (auxY + margem > this.parent.y + this.parent.height))
				{
					this.gotoAndStop(this.totalFrames);
				}
				
			this.VoltarPosicao();
		}
		
		public function VoltarPosicao():void
		{
			this.x = PosicaoOriginal.x;
			this.y = PosicaoOriginal.y;
		}
	}
}