package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class AvatarPart extends MovieClip
	{
		public var colorTrans:ColorTransform;
		public var PosicaoOriginal:Object = new Object();

		public function AvatarPart() 
		{
			if(colorivel)
			{
				Colorivel = colorivel;
			}
			PosicaoOriginal.x = this.x;
			PosicaoOriginal.y = this.y;
		}
		
		/**
		* Retorna o clip que é colorível
		* @author Galindo
		*/
		public function get Colorivel():MovieClip
		{
			return colorivel;
		}
		
		/**
		* Define o clip que será colorível
		* @author Galindo
		*/
		public function set Colorivel(mc:MovieClip):void
		{
			colorivel = mc;
		}
		
		public function AtualizaCor():void
		{
			if(Colorivel != null)
			{
				Colorivel.transform.colorTransform = colorTrans;
			}
		}
		
		/**
		* Evento do mouse para avançar o frame.
		* @author Carvalho
		*/
		public function NextEvent(e:MouseEvent=null)
		{
			NextPart();
			
			if(colorivel)
			{
				Colorivel = colorivel;
				AtualizaCor();
			}
		}
		
		/**
		* Evento do mouse para voltar o frame.
		* @author Carvalho
		*/
		public function PrevEvent(e:MouseEvent=null)
		{
			PreviousPart();
			
			if(colorivel)
			{
				Colorivel = colorivel;
				AtualizaCor();
			}
		}
		
		/**
		* Vai para o frame seguinte, de forma circular.
		* Obs.: É diferente da função 'nextFrame'.
		* @author Carvalho
		*/
		public function NextPart()
		{
			var frame:uint = currentFrame + 1 > totalFrames ? 1 : currentFrame + 1;
			gotoAndStop(frame);
		}
		
		/**
		* Vai para o frame anterior, de forma circular.
		* Obs.: É diferente da função 'prevFrame'.
		* @author Carvalho
		*/
		public function PreviousPart()
		{
			var frame:uint = currentFrame - 1 == 0 ? totalFrames : currentFrame - 1;
			gotoAndStop(frame);
		}
		
		/**
		* Vai para um frame aleatório.
		* @author Carvalho
		*/
		public function Randomize()
		{
			var randomFrame:uint = Math.random() * totalFrames;
			++randomFrame;
			gotoAndStop(randomFrame);
		}
	}
}