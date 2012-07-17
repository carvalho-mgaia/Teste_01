package
{
	// Pacotes padrão do Flash
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.geom.Matrix;
	import flash.filters.GlowFilter;
	import fl.transitions.Tween;
	import fl.motion.easing.Bounce;
	
	// Pacotes da biblioteca Corelib
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	// Pacotes da Graph API Web do Facebook
	import com.facebook.graph.*;
	import com.facebook.graph.controls.*;
	import com.facebook.graph.core.*;
	import com.facebook.graph.data.*;
	import com.facebook.graph.net.*;
	import com.facebook.graph.utils.*;
	
	// Pacotes referentes ao projeto
	import graficos.*;
	import BoxAcessorios.*;
	import paleta.*;
	import flash.text.TextFieldType;
	import fl.transitions.easing.Regular;
	import fl.transitions.TweenEvent;
	
	/**
	* Classe principal do aplicativo Emotigum-Me para Facebook.
	* @author Carvalho
	*/
	public class Main extends MovieClip 
	{		
		private var MAX_WIDTH_MOSAICO:uint = 300;
		
		private var bg:Cenario = new Cenario();
		
		// Imagens do avatar
		private var ImgThumb:BitmapData;
		private var ImgAvatar:BitmapData;
		private var ImgCapa:BitmapData;
		private var ImgExemplo:BitmapData;
		private var ImgComposta:BitmapData;
		
		// Paletas
		private var paletaCorpo:Paleta = new Paleta();
		private var paletaOlho:Paleta = new Paleta();
		private var paletaCabelo:Paleta = new Paleta();
		private var paletaBochecha:Paleta = new Paleta();
		private var paletaMaos:Paleta = new Paleta();
		private var paletaAcessorio:Paleta = new Paleta();
		private var paletaOculos:Paleta = new Paleta();
		private var paletaBoca:Paleta = new Paleta();
		
		private var AppDirectory:String = "http://www.mgaia.com.br/dev/emotigum-me/";
		private var APP_ID:String = "383032915067187";
		private const FB_NAME:String = "emotigum-me";
		private var CANVAS_URL:String = "http://www.mothergaia.com.br/dev/emotigum-me/";
		private var APP_URL:String = "https://apps.facebook.com/" + FB_NAME + "/";
		private var SCOPE:Array = ["publish_stream", "user_about_me", "photo_upload", "user_location", "user_birthday"];
		private var FacebookUID:String = "4";
		private var UsrName:String;
		private var UsrBirthday:String;
		private var UsrLocation:String;
		
		//Outras variáveis
		private var montadorTarget:AvatarPart;
		private var draggingTarget:AcessorioDrag;
		private var myGlow:GlowFilter = new GlowFilter(0xFFFFFF,0.5,20,20,5);
		private var filtroGlow:Array = [myGlow];
		private var mySharedObject:SharedObject = SharedObject.getLocal(Constantes.SharedObjectName);
		
		private var Boneco:MovieClip = new MCBoneco();
		private var Stg:Stage;
		private var tarjaLoading:TarjaLoading = new TarjaLoading();
		private var thumbStreamFile:String;
		
		
		/**
		* Construtor da classe, não recebe parâmetros.
		* @author Carvalho
		*/
		private const TEST_MODE:Boolean = false;
		public function Main()
		{
			stop();
			
			// Configura o stage
			if(stage)
			{
				InitApp(stage);
			}
		}
		
		/**
		* Define o stage principal da aplicação.
		* @author Galindo
		*/
		public function SetStage(stg:Stage):void
		{
			trace("SetStage: " + stg);
			Stg = stg;
		}
		
		/**
		* Inicia os processos do aplicativo.
		* @author Galindo
		*/
		public function InitApp(stg:Stage):void
		{
			Output.text = "Inicializando...";
			Output.visible = false;
			
			SetStage(stg);
			
			// Configura o Stage
			Stg.showDefaultContextMenu = false;
			Stg.scaleMode = StageScaleMode.EXACT_FIT;
			Stg.align = StageAlign.TOP_LEFT;
			
			// Configura o carregamento
			this.addEventListener(Event.ENTER_FRAME, PreloaderLoop);
			// Cria as paletas de cores
			CriaPaletas();
			// Randomiza o boneco
			RandomizaBoneco();
			
			//Easter Egg
			tv.addEventListener(MouseEvent.CLICK, ClickTV);
		}
		
		/**
		* Evento de carregamento do arquivo, previne alguns bugs antes do swf ser carregado na memória.
		* Após o carregamento executa também uma inicialização com Facebook, já que o Login só pode
		*  ser acessado por pop-up se estiver atrelado a algum evento do usuário (MouseEvent).
		* @author Galindo
		*/
		private function PreloaderLoop(e:Event):void
		{
			if(this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal)
			{
				if(TEST_MODE)
				{
					GoToMontador();
				}
				else
				{
					BotaoCarregando.Barra.scaleX = 0;
					BotaoCarregando.Brilho.visible = false;
					this.addEventListener(Event.ENTER_FRAME, Loop);
				}
				
				// Após o carregamento do arquivo, conecta com o App
				Facebook.init(APP_ID, OnFacebookInit);
				// Remove o evento do Preloader
				this.removeEventListener(Event.ENTER_FRAME, PreloaderLoop);
			}
		}
		
		/**
		* Evento para animação da barra.
		* @author Galindo
		*/
		private var PctBarra:uint;
		private var IncrementoBarra:Number = 0.015;
		private function Loop(e:Event):void
		{
			BotaoCarregando.Barra.scaleX += Math.random() * 0.04;
			PctBarra = BotaoCarregando.Barra.scaleX * 100;
			if(PctBarra > 100) PctBarra = 100;
			BotaoCarregando.Txt.text = PctBarra + "%";
			
			if(BotaoCarregando.Barra.scaleX >= 1)
			{
				BotaoCarregando.Barra.scaleX = 1;
				InitBotao();
				removeEventListener(Event.ENTER_FRAME, Loop);
			}
		}
		
		/**
		* Configura o botão 'Crie seu Emotigum'
		* @author Galindo
		*/
		private function InitBotao():void
		{
			BotaoCarregando.Mascara.visible = false;
			BotaoCarregando.Fundo2.visible = false;
			BotaoCarregando.Barra.visible = false;
			BotaoCarregando.Brilho.visible = true;
			BotaoCarregando.Txt.text = "CRIE SEU EMOTIGUM";
			
			BotaoCarregando.buttonMode = true;
			BotaoCarregando.Txt.mouseEnabled = false;
			BotaoCarregando.addEventListener(MouseEvent.MOUSE_DOWN, BotaoCarregando_Evt);
			BotaoCarregando.addEventListener(MouseEvent.MOUSE_OVER, BotaoCarregando_Evt);
			BotaoCarregando.addEventListener(MouseEvent.MOUSE_OUT, BotaoCarregando_Evt);
		}
		
		/**
		* Evento do botão de carregando.
		* @author Galindo
		*/
		private function BotaoCarregando_Evt(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					Output.appendText("\nFazendo Login..");
					// Faz o login e autorização, com a janela pop-up do Facebook
					var opts:Object = {scope: SCOPE.join(",")};
					Facebook.login(OnFacebookLogin, opts);
					break;
				
				case MouseEvent.MOUSE_OVER:
					BotaoCarregando.Fundo2.visible = true;
					break;
				
				case MouseEvent.MOUSE_OUT:
					BotaoCarregando.Fundo2.visible = false;
					break;
				
				default:
					break;
			}
		}
		
		/**
		* Callback de inicialização do facebook.
		* @author Galindo
		*/
		private function OnFacebookInit(success:FacebookAuthResponse, fail:Object):void
		{
			// Já conectado com o App
			if(success)
			{
				Output.appendText("\nInicializado com Facebook.");
				Output.appendText("\nUid: " + success.uid);
				Output.appendText("\nExpire Date: " + success.expireDate);
				
				// Atribui a ID do usuário no FB
				FacebookUID = success.uid;
			}
		}
		
		/**
		* Callback dos dados do jogador
		* @author Carvalho
		*/
		private function CallbackUserData(result:Object, fail:Object):void
		{
			if(result)
			{
				// Vai para a tela do editor
				GoToMontador();
				
				Output.appendText("\nUserData Sucesso!");
				// Recupera os dados do request feito ao FB
				UsrName = result.name;
				//UsrBirthday = result.birthday;
				//UsrLocation = result.location.name;
			}
			if(fail)
			{
				Output.appendText("\nUserData Fail.");
				for(var it:String in fail)
				{
					Output.appendText("\n" + it + ": " + fail[it]);
				}
				UsrName = "CallbackUserData Fail";
				// Chama novamente, recupera dados do jogador
				Facebook.api("/me", CallbackUserData);
			}
		}
		
		/**
		* Callback do login com o Facebook
		* @author Galindo
		*/
		private function OnFacebookLogin(success:FacebookAuthResponse, fail:Object):void
		{
			if(success)
			{
				Output.appendText("\nFacebook Login efetuado com sucesso!");
				// Atribui a ID do usuário no FB
				FacebookUID = success.uid;
				// Recupera dados do jogador
				Facebook.api("/me", CallbackUserData);
				Output.appendText("\nRecuperando dados do jogador...");
			}
			else
			{
				Output.appendText("\nFacebook Login fail.");		
			}
		}
		
		/*public function GoToMosaico()
		{
			gotoAndStop("Mosaico");
			
			var myRequest:URLRequest = new URLRequest(AppDirectory + "php/getAvatares.php");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, GetMosaicoReader);
			urlLoader.load(myRequest);
		}*/
		
		/**
		* Vai para a tela do montador
		* @author Carvalho
		*/
		public function GoToMontador(voltando:Boolean = false)
		{
			gotoAndStop("Montador");
			this.addChild(Boneco);
			caixaCores.visible = false;
			
			CriaPaletas();
			
			AddMontadorEventos();
			
			Boneco.x = Constantes.InfoBoneco.x = 300;
			Boneco.y = Constantes.InfoBoneco.y = 145;
			Boneco.scaleX = Boneco.scaleY = 1;
			Constantes.InfoBoneco.width = Boneco.width;
			Constantes.InfoBoneco.height = Boneco.height;
			
			// Configura a área de desenho
			var auxMC:Mascara = new Mascara();
			var areaDesenho:Sprite = new Sprite();
			areaDesenho.addChild(auxMC);
			areaDesenho.width = Boneco.width;
			areaDesenho.height = Boneco.height;
			auxMC.visible = false;
			auxMC.alpha = 0;
			boxDesenho.mascara = auxMC;
			Boneco.addChild(areaDesenho);
			boxDesenho.AreaDesenho = areaDesenho;
			boxDesenho.MyStage = Stg;
			boxDesenho.Desenhos = Boneco.Desenhos;
			
			// Adicionar o logo da chiclets, POR CIMA da área de desenho
			Boneco.addChild(Boneco.LogoChiclets);
			Boneco.LogoChiclets.blendMode = BlendMode.INVERT;
			
			// Carrega a foto do usuário
			CarregaFoto();
			
			boxDesenho.isOpen = false;
			SetaDir.visible = SetaEsq.visible = false;
			
			//Tween do destaque dos botões
			var myTween:Tween = new Tween(glowMaskRand, "alpha", Regular.easeIn, 0, 0.7, 1, true);
			var myTween2:Tween = new Tween(glowMask, "alpha", Regular.easeIn, 0, 0.7, 1, true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, loopTween);
			myTween2.addEventListener(TweenEvent.MOTION_FINISH, loopTween);
			
			glowMaskRand.mouseEnabled = false;
			glowMask.mouseEnabled = false;
			
			// Seleciona o cabelo
			SetaDir.visible = SetaEsq.visible = true;
			
			caixaCores.visible = true;			
			paletaCabelo.visible = true;
			
			montadorTarget = Boneco.cabelo;
			montadorTarget.filters = filtroGlow;
			
			SetaDir.addEventListener(MouseEvent.CLICK, montadorTarget.NextEvent);
			SetaEsq.addEventListener(MouseEvent.CLICK, montadorTarget.PrevEvent);
			
			//Move as setas para o lado da parte clicada
			SetaDir.y = montadorTarget.y + Boneco.y + (montadorTarget.height / 2);
			SetaEsq.y = montadorTarget.y + Boneco.y + (montadorTarget.height / 2);
		}
		
		function loopTween(e:TweenEvent):void
		{
			 e.target.yoyo();
		}
		
		/**
		* Cria palheta de cores
		* @author Carvalho
		*/
		private function CriaPaletas():void
		{
			var qtdPorLinha:uint = 5;
			var tam:Number = 23;
			var posx:Number = Constantes.PosicaoPaleta.x;
			var posy:Number = Constantes.PosicaoPaleta.y;
			var espacamento:uint = 5;
			
			paletaCabelo.x = posx;
			paletaCabelo.y = posy;
			addChild(paletaCabelo);
			paletaCabelo.Cria(GeradorDePaletas.PaletaCabelo, tam, tam, qtdPorLinha, espacamento, false);
			paletaCabelo.Alvo = Boneco.cabelo;
			paletaCabelo.visible = false;
			
			paletaOlho.x = posx;
			paletaOlho.y = posy;
			addChild(paletaOlho);
			paletaOlho.Cria(GeradorDePaletas.PaletaOlhos, tam, tam, qtdPorLinha, espacamento, false);
			paletaOlho.Alvo = Boneco.olho;
			paletaOlho.visible = false;
			
			paletaCorpo.x = posx;
			paletaCorpo.y = posy;
			addChild(paletaCorpo);
			paletaCorpo.Cria(GeradorDePaletas.PaletaCorpo, tam, tam, qtdPorLinha, espacamento, false);
			paletaCorpo.Alvo = Boneco.corpo;
			paletaCorpo.visible = false;
			
			paletaAcessorio.x = posx;
			paletaAcessorio.y = posy;
			addChild(paletaAcessorio);
			paletaAcessorio.Cria(GeradorDePaletas.PaletaCabelo, tam, tam, qtdPorLinha, espacamento, false);
			paletaAcessorio.Alvo = Boneco.acessorio;
			paletaAcessorio.visible = false;
			
			paletaBochecha.x = posx;
			paletaBochecha.y = posy;
			addChild(paletaBochecha);
			paletaBochecha.Cria(GeradorDePaletas.PaletaCabelo, tam, tam, qtdPorLinha, espacamento, false);
			paletaBochecha.Alvo = Boneco.bochecha;
			paletaBochecha.visible = false;
			
			paletaMaos.x = posx;
			paletaMaos.y = posy;
			addChild(paletaMaos);
			paletaMaos.Cria(GeradorDePaletas.PaletaCabelo, tam, tam, qtdPorLinha, espacamento, false);
			paletaMaos.Alvo = Boneco.maos;
			paletaMaos.visible = false;
			
			paletaOculos.x = posx;
			paletaOculos.y = posy;
			addChild(paletaOculos);
			paletaOculos.Cria(GeradorDePaletas.PaletaCabelo, tam, tam, qtdPorLinha, espacamento, false);
			paletaOculos.Alvo = Boneco.oculos;
			paletaOculos.visible = false;
			
			paletaBoca.x = posx;
			paletaBoca.y = posy;
			addChild(paletaBoca);
			paletaBoca.Cria(GeradorDePaletas.PaletaCabelo, tam, tam, qtdPorLinha, espacamento, false);
			paletaBoca.Alvo = Boneco.boca;
			paletaBoca.visible = false;
		}
		
		/**
		* Randomiza o boneco
		* @author Carvalho
		*/
		private function RandomizaBoneco():void
		{
			Boneco.cabelo.Randomize();
			Boneco.bochecha.Randomize();
			Boneco.maos.Randomize();
			Boneco.corpo.Randomize();
			Boneco.olho.Randomize();
			Boneco.boca.Randomize();
			
			//Remove os acessórios.
			Boneco.acessorio.gotoAndStop(Boneco.acessorio.totalFrames);
			Boneco.oculos.gotoAndStop(Boneco.oculos.totalFrames);
			Boneco.extra.gotoAndStop(Boneco.extra.totalFrames);
			
			//Randomiza cores
			paletaCorpo.RandomizaCor();
			paletaOlho.RandomizaCor();
			paletaCabelo.RandomizaCor();
			paletaMaos.RandomizaCor();
			paletaAcessorio.RandomizaCor();
			paletaOculos.RandomizaCor();
			paletaBochecha.RandomizaCor();
			paletaBoca.RandomizaCor();
		}
		
		/**
		* Carrega a foto do usuário.
		* Nota da documentação: "(...) redirect to URL of the user's profile picture
		*  (use http://graph.facebook.com/__UserID__/picture?type=square|small|normal|large
		* @author Galindo
		*/
		private var CarregadorFoto:Loader = new Loader();
		private var urlFotoLoader:URLLoader;
		private function CarregaFoto():void
		{
			Output.appendText("\nCarregando endereço da foto.");
			
			var urlFoto:String = "http://graph.facebook.com/" + FacebookUID + "/picture?type=normal";
			var urlReqFoto:URLRequest = new URLRequest(urlFoto);
			
			urlFotoLoader = new URLLoader();
			urlFotoLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlFotoLoader.addEventListener(Event.COMPLETE, urlLoaderComplete);
			
			urlFotoLoader.load(urlReqFoto);
		}
		
		private function urlLoaderComplete(e:Event):void
		{
			Output.appendText("\nImagem carregada no modo ByteArray!");
			CarregadorFoto.contentLoaderInfo.addEventListener(Event.COMPLETE, FotoComplete);
			CarregadorFoto.loadBytes(urlFotoLoader.data as ByteArray);
		}
		
		private function FotoComplete(e:Event):void
		{
			var bmp:Bitmap = e.currentTarget.content as Bitmap;
			bmp.x = -4;
			bmp.y = -2;
			bmp.rotation = -10;
			bmp.smoothing = true;
			MascaraTv.addChild(bmp);
			bmp.mask = MascaraTv.Interno;
		}
		
		/**
		* Vai para a tela de customização do balão
		* @author Carvalho
		*/
		private function GoToBalao():void
		{
			gotoAndStop("Balão");
			
			balao.texto.text = Constantes.TextoInicial;
			
			composto.addChild(balao);
			
			balao.x = balao.x - composto.x;
			balao.y = balao.y - composto.y;
			
			AddBalaoEventos();
		}
		
		/**
		* Vai para a tela final
		* @author Carvalho
		*/
		private function GoToFinal():void
		{
			gotoAndStop("Final");
			
			AddFinalEventos();
			
			var auxAvatar:Bitmap = new Bitmap(ImgAvatar);
			auxAvatar.smoothing = true;
			AvatarContainer.addChild(auxAvatar);
			AvatarContainer.scaleX = AvatarContainer.scaleY = 0.7;
			
			var auxBmp:Bitmap = new Bitmap(ImgCapa);
			auxBmp.smoothing = true;
			ComposicaoContainer.addChild(auxBmp);
			ComposicaoContainer.scaleX = 0.42;
			ComposicaoContainer.scaleY = 0.42;
			
			var auxCapa:Bitmap = new Bitmap(ImgCapa);
			auxCapa.smoothing = true;
			CapaContainer.addChild(auxCapa);
			CapaContainer.scaleX = 0.65;
			CapaContainer.scaleY = 0.65;
			
			var auxExemplo:Bitmap = new Bitmap(ImgExemplo);
			auxExemplo.smoothing = true;
			AvatarFrame.ExemploContainer.addChild(auxExemplo);
		}
		
		/**
		* Cria a barra de amigos
		* @author Carvalho
		*/
		private function CriaBarraAmigos():void
		{
			Output.appendText("\n Cria Barra Amigos");
			try
			{
				Facebook.fqlQuery("SELECT uid,name FROM user WHERE uid IN(SELECT uid2 FROM friend WHERE uid1 = " + FacebookUID + ") AND is_app_user=1", CallbackAmigosJogam);
			}
			catch (e:Error) { Output.appendText("\n Exception: " + e); }
		}
		
		/**
		* Callback do fql que descobre os amigos que jogam
		* @author Carvalho
		*/
		private function CallbackAmigosJogam(result:Object, fail:Object):void
		{
			if (result)
			{
				var myRequest:URLRequest = new URLRequest(AppDirectory + "php/getAvatares.php");
				var urlLoader:URLLoader = new URLLoader();
				var variaveis:URLVariables = new URLVariables();
				
				var query:String = "SELECT UID, nome FROM usuarios WHERE uid IN (";
				for (var i:uint = 0; i < result.length; ++i)
				{
					query += result[i].uid + ",";
				}
				query +=  FacebookUID + ") group by UID";
				variaveis.query = query;
				
				Output.appendText("\nQuery : " + query);
				
				myRequest.method = URLRequestMethod.POST;
				myRequest.data = variaveis;
				urlLoader.addEventListener(Event.COMPLETE, AdicionaAmigos);
				urlLoader.load(myRequest);
			}
			else
				Output.appendText("\n fail " + fail);
		}
		
		/**
		* Adiciona amigos que jogam na barra inferior
		* @author Carvalho
		*/
		private function AdicionaAmigos(e:Event):void
		{
			var arrLinhas:Array = e.target.data.split("|");
			var barraAmigos:BarraInferior = barraAmigos;
			var arrAvatares:Array = new Array();
			var totalLinhas:uint = arrLinhas.length - 1;
			
			Output.appendText("\ntotalLinhas " + totalLinhas);
			
			for(var i:uint = 0; i < (totalLinhas > 50? 50 : totalLinhas); ++i)
			{
				var arrColunas:Array = arrLinhas[i].split("&");
				
				//Output.appendText("\n id " + arrColunas[1]);
				//Output.appendText("\n name " + arrColunas[2]);
				
				arrAvatares[i] = {
					 imgLink: new URLRequest(CANVAS_URL + "/thumb/" + arrColunas[1] + "_thumb.png"),
					nome: arrColunas[2].toString()
				};
			}
			barraAmigos.CriaAvatares(arrAvatares);
		}
		
		
		/**
		* Vai para a tela de seleção de cenário
		* @author Carvalho
		*/
		private var FrameCenario:uint = 1;
		private function goToCenario():void
		{
			gotoAndStop("Cenario");
			
			AddCenarioEventos();
			CriaBarraAmigos();
			
			// adiciona fundo no movieclip do cenário
			//composto.BGContainer.addChild(bg);			
			composto.addChild(Boneco);
			
			// posiciona o boneco
			Boneco.x = 70;
			Boneco.y = 20;
			Boneco.scaleX = 0.7;
			Boneco.scaleY = 0.7;
			
			composto.cena.gotoAndStop(FrameCenario);
			
			CenarioPreview.cenario1.gotoAndStop(FrameCenario);
			CenarioPreview.cenario2.gotoAndStop(FrameCenario);
			CenarioPreview.cenario2.NextPart();
			CenarioPreview.cenario3.gotoAndStop(FrameCenario);
			CenarioPreview.cenario3.NextPart();
			CenarioPreview.cenario3.NextPart();
			CenarioPreview.cenario4.gotoAndStop(FrameCenario);
			CenarioPreview.cenario4.NextPart();
			CenarioPreview.cenario4.NextPart();
			CenarioPreview.cenario4.NextPart();
			
			//Configura máscara
			composto.cena.mask = composto.mascara;
		}
		
		/**
		* Salva avatar criado no servidor e na memória
		* @author Carvalho
		*/
		private function SalvarThumb()
		{
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			
			//Salva thumb no servidor
			var thumbRequest:URLRequest = new URLRequest(AppDirectory + "php/SaveThumb.php?uid=" + FacebookUID);
			var thumbLoader:URLLoader = new URLLoader();
			
			thumbRequest.requestHeaders.push(header);
			thumbRequest.method = URLRequestMethod.POST;
			thumbRequest.data = PNGEncoder.encode(ImgThumb);
			thumbLoader.addEventListener(Event.COMPLETE, ThumbComplete);
			thumbLoader.load(thumbRequest);
		}
		
		
		/**
		* Salva o boneco junto com o fundo
		* @author Carvalho
		*/
		private function SalvarEmotigum()
		{
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			
			var myRequest:URLRequest = new URLRequest(AppDirectory + "php/savePNG.php?uid=" + FacebookUID + 
													  "&nome=" + UsrName + "&birthday=" + UsrBirthday + "&location=" + UsrLocation);
			var loader:URLLoader = new URLLoader();
			
			myRequest.requestHeaders.push(header);
			myRequest.method = URLRequestMethod.POST;
			myRequest.data = PNGEncoder.encode(ImgAvatar);
			loader.addEventListener(Event.COMPLETE, SaveComplete);
			loader.load(myRequest);
		}
		
		private function GetComposta():BitmapData
		{
			var PNGSource:BitmapData = new BitmapData(composto.mascara.width, composto.mascara.height);
			PNGSource.draw(composto);
			
			return(PNGSource);
		}
		
		/*
		* Salva exemplo do avatar do facebook
		* @author Carvalho
		*/
		private function SalvarAvatar():void
		{
			// Retira filtro que indica parte ativa
			if (montadorTarget)
				montadorTarget.filters = [];
			
			ImgExemplo = new BitmapData(180,192);
			var mtx:Matrix = new Matrix();
			mtx.scale(1.18,1.18);
			mtx.translate(-3,-100);
			
			ImgExemplo.draw(Boneco,mtx);
		}
		
		/**
		* 
		* @author Carvalho
		*/
		private function GetBackground():BitmapData
		{
			var cenario:Cenario = new Cenario();
			cenario.gotoAndStop(composto.cena.currentFrame);
			cenario.fundo.x = 0;
			cenario.fundo.y = 0;
			
			var PNGSource:BitmapData = new BitmapData(cenario.width, cenario.height);
			PNGSource.draw(cenario);
			
			return(PNGSource);
		}
		
		private function GetAvatar(scale:Number = 1):BitmapData
		{
			var PNGSource:BitmapData = new BitmapData(Boneco.width * scale, Boneco.height * scale);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale,scale);
			PNGSource.draw(Boneco,matrix);
			
			return(PNGSource);
		}
		
		/**
		* Chamado quano termina de salvar o arquivo;
		* @author Galindo
		*/
		private function SaveComplete(e:Event):void
		{
			Output.appendText("\nSaveComplete: " + e.target.data);
		}
		
		/**
		* Chamado quano termina de salvar o arquivo;
		* @author Galindo
		*/
		private function ThumbComplete(e:Event):void
		{
			Output.appendText("\n Thumb Complete: " + e.target.data);
			thumbStreamFile = e.target.data;
		}
		
		private function Publish(foto:ByteArray,callback:Function = null, 
								 messg:String = "Cara, olha que TOP meu emotigum!"):void
		{
			if (callback == null)
				callback = PhotoCallback;
			
			Output.appendText("\nUpload photo...");
			// Enviando foto e postando no FB
			//var bmp:Bitmap = new Bitmap(PNGSource, "auto", true);
			Facebook.api(
				"/me/photos",
				callback,
				{message: messg,
				image: foto,
				fileName: "fileName.png"},
				"POST"
			);
		}
		
		/**
		* Callback do upload da foto no FB.
		* @author Galindo
		*/
		private function PhotoCallback(result:Object, fail:Object):void
		{
			if(result)
			{
				Output.appendText("\nPhoto Result: " + result);
				Output.appendText("\nid: " + result.id);
			}
			if(fail)
			{
				Output.appendText("\nPhoto Fail: " + fail);
			}
			
			tarjaLoading.ShowPopUp("Concluído! A sua foto foi salva no álbum 'Emotigum-Me Photos'");
		}
		
		/**
		* Callback do botão aleatório
		* @author Carvalho
		*/
		private function RandomizeCallback(e:Event):void
		{
			RandomizaBoneco();
		}
		
		private function GoToResultado():void
		{
			RemoveBalaoEventos();
			
			Output.appendText("FirstPlay " + mySharedObject.data.FirstPlay);
			
			if (mySharedObject.data.FirstPlay != "true")
			{
				mySharedObject.data.FirstPlay = "true";
			
				// Publica no mural automaticamente quando vai para a última tela
				Facebook.api(
					"/me/feed",
					null,
					{message: "Eu entrei na máquina de Chiclets e virei esse Emotigum! Não ficou demais?",
					picture: CANVAS_URL + "/streamThumb/" + thumbStreamFile,
					link: "apps.facebook.com/emotigum-me",
					name: "Clique e faça um Emotigum com a sua cara.",
					caption: "Meu Emotigum!",
					description: "Com o Emotigum Me todo mundo vai entrar nessa! Corra e faça o seu!"},
					"POST"
				);
			}
			
			mySharedObject.flush();
			
			gotoAndStop("Resultado");
			
			AddResultEventos();
		}
		
		/**
		* Adiciona eventos da tela de seleção do cenário
		* @author Carvalho
		*/
		private function AddCenarioEventos():void
		{
			btnVoltar.addEventListener(MouseEvent.CLICK, CenarioVoltarListener);
			btnOKcenario.addEventListener(MouseEvent.CLICK, cenarioOKListener);
			btnProx.addEventListener(MouseEvent.MOUSE_DOWN, BtnProxCenario_Md);
			btnAnt.addEventListener(MouseEvent.MOUSE_DOWN, BtnAntCenario_Md);
		}
		
		/**
		* Evento de clique no botão 'próximo' dos cenários.
		* @author Carvalho
		*/
		private function BtnProxCenario_Md(e:MouseEvent):void
		{
			composto.cena.NextEvent();
			CenarioPreview.cenario1.NextEvent();
			CenarioPreview.cenario2.NextEvent();
			CenarioPreview.cenario3.NextEvent();
			CenarioPreview.cenario4.NextEvent();
			
			FrameCenario = composto.cena.currentFrame;
		}
		
		/**
		* Evento de clique no botão 'próximo' dos cenários.
		* @author Carvalho
		*/
		private function BtnAntCenario_Md(e:MouseEvent):void
		{
			composto.cena.PrevEvent();
			CenarioPreview.cenario1.PrevEvent();
			CenarioPreview.cenario2.PrevEvent();
			CenarioPreview.cenario3.PrevEvent();
			CenarioPreview.cenario4.PrevEvent();
			
			FrameCenario = composto.cena.currentFrame;
		}
		
		
		/**
		* Adiciona eventos da tela final
		* @author Carvalho
		*/
		private function AddFinalEventos():void
		{
			btnSalvarAvatar.addEventListener(MouseEvent.CLICK, SaveAvatarListener);
			btnSalvarCapa.addEventListener(MouseEvent.CLICK, SaveCapaListener);
			btnFechar.addEventListener(MouseEvent.CLICK, btnFecharListener);
		}
		
		/**
		* Adiciona eventos da tela resultado
		* @author Carvalho
		*/
		public function AddResultEventos():void
		{
			btnVoltarResult.addEventListener(MouseEvent.CLICK, ResultVoltarListener);
			btnSalvarResult.addEventListener(MouseEvent.CLICK, ResultOKListener);
			btnCompartilhar.addEventListener(MouseEvent.CLICK, CompartilharListener);
		}
		
		
		/**
		* Adiciona eventos da tela de seleção do cenário
		* @author Carvalho
		*/
		public function AddBalaoEventos()
		{
			btnVoltarBalao.addEventListener(MouseEvent.CLICK, BalaoVoltarListener);
			btnOKBalao.addEventListener(MouseEvent.CLICK, BalaoOKListener);
			balao.texto.addEventListener(MouseEvent.CLICK, TextoBalaoClick);
		}
		
		public function RemoveBalaoEventos()
		{
			btnVoltarBalao.removeEventListener(MouseEvent.CLICK, BalaoVoltarListener);
			btnOKBalao.removeEventListener(MouseEvent.CLICK, BalaoOKListener);
			balao.texto.selectable = false;
			balao.texto.type = TextFieldType.DYNAMIC;
		}
		
		private function ItemOver(e:MouseEvent):void
		{
			var targ:AvatarPart = (e.target is AvatarPart) ? (e.target as AvatarPart) : (e.target.parent as AvatarPart);
			
			targ.filters = filtroGlow;
		}
		
		private function ItemOut(e:MouseEvent):void
		{
			var targ:AvatarPart = (e.target is AvatarPart) ? (e.target as AvatarPart) : (e.target.parent as AvatarPart);
			
			if (targ != montadorTarget)
				targ.filters = [];
		}
		
		static function getClass(obj:Object):Class 
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		/**
		* Adiciona eventos da tela do montador
		* @author Carvalho
		*/
		private function AddMontadorEventos():void
		{			
			btnOK.addEventListener(MouseEvent.CLICK, montadorOKListener);
			btnRandom.addEventListener(MouseEvent.CLICK, RandomizeCallback);
			boxAcessorios.mouseEnabled = false;
			btnAcessorios.addEventListener(MouseEvent.CLICK, btnAcessoriosListener);
			btnDesenhar.addEventListener(MouseEvent.CLICK, btnDesenharListener);
			
			AddBonecoEventos();
			AddEventosAcessorios();
		}
		
		/**
		* Evento do botão acessórios que faz o tween da box
		* @author Carvalho
		*/
		
		private var tweenDesenhar:Tween;
		private function btnDesenharListener(e:MouseEvent):void
		{
			if (montadorTarget)
				montadorTarget.filters = [];
				
			// fechando
			if (boxDesenho.y < 167)
			{
				tweenDesenhar = new Tween(boxDesenho,"y",Bounce.easeOut, 162,346,1,true);
				boxDesenho.isOpen = false;
			}
			// abrindo
			else if (boxDesenho.y > 337)
			{
				tweenDesenhar = new Tween(boxDesenho,"y",Bounce.easeOut, 346,162,1,true);
				boxDesenho.isOpen = true;
			}
			
			// Se outra box está no espaço, esconde-a
			if (boxAcessorios.y > 95)
			{
				tweenAcessorios = new Tween(boxAcessorios,"y",Bounce.easeOut, 149,-41,1,true);
			}
		}
		
		/**
		* Evento do botão acessórios que faz o tween da box
		* @author Carvalho
		*/
		private var tweenAcessorios:Tween;
		private function btnAcessoriosListener(e:MouseEvent):void
		{
			boxDesenho.isOpen = false;
			
			if (montadorTarget)
				montadorTarget.filters = [];
				
			// Abrindo
			if (boxAcessorios.y < 15)
			{
				tweenAcessorios = new Tween(boxAcessorios,"y",Bounce.easeOut, -41,149,1,true);
			}
			// Fechando
			else if (boxAcessorios.y > 77)
			{
				tweenAcessorios = new Tween(boxAcessorios,"y",Bounce.easeOut, 149,-41,1,true);
			}
			
			// Se outra box está no espaço, esconde-a
			if (boxDesenho.y < 167)
			{
				tweenDesenhar = new Tween(boxDesenho,"y",Bounce.easeOut, 162,346,1,true);
			}
		}
		
		/**
		* Adiciona eventos dos acessórios
		* @author Carvalho
		*/
		private function AddEventosAcessorios():void
		{
			var i:uint;
			
			for (i = 1; i <= 5; ++i)
			{
				this["boxAcessorios"]["oculos"+i].addEventListener(MouseEvent.MOUSE_DOWN, DragStart);
				this["boxAcessorios"]["oculos"+i].addEventListener(MouseEvent.MOUSE_UP, DragStop);
			}
			
			for (i = 1; i <= 11; ++i)
			{
				this["boxAcessorios"]["cabelo"+i].addEventListener(MouseEvent.MOUSE_DOWN, DragStart);
				this["boxAcessorios"]["cabelo"+i].addEventListener(MouseEvent.MOUSE_UP, DragStop);
			}
			
			boxAcessorios.extra1.addEventListener(MouseEvent.MOUSE_DOWN, DragStart);
			boxAcessorios.extra1.addEventListener(MouseEvent.MOUSE_UP, DragStop);
		}
		
		private function DragStart(e:MouseEvent):void
		{
			var acessor:BoxAcessorios.DragableItem = (e.target.parent is BoxAcessorios.DragableItem) ? (e.target.parent as BoxAcessorios.DragableItem) : (e.target.parent.parent as BoxAcessorios.DragableItem);
			var i:uint;
			//acessor.startDrag();
			
			for (i = 1; i <= 5; ++i)
			{
				if (acessor is (getDefinitionByName("Oculos"+i) as Class))
				{
					draggingTarget = Boneco.oculos;
					Boneco.oculos.gotoAndStop(i);
					
				}
			}
			for (i = 1; i <= 11; ++i)
			{
				if (acessor is (getDefinitionByName("Cabelo"+i) as Class))
				{
					draggingTarget = Boneco.acessorio;
					Boneco.acessorio.gotoAndStop(i);
				}
			}
			for (i = 1; i <= 1; ++i)
			{
				if (acessor is (getDefinitionByName("Extra"+i) as Class))
				{
					draggingTarget = Boneco.extra;
					Boneco.extra.gotoAndStop(i);
				}
			}
			
			draggingTarget.FrameChanged();
			draggingTarget.startDrag(true);
			draggingTarget.addEventListener(MouseEvent.MOUSE_DOWN, ItemDown);
			draggingTarget.addEventListener(MouseEvent.MOUSE_OVER, ItemOver);
			draggingTarget.addEventListener(MouseEvent.MOUSE_OUT, ItemOut);
			//draggingTarget.addEventListener(MouseEvent.CLICK, Click);
			
			//this.stage.addEventListener(MouseEvent.MOUSE_MOVE, StgMouseMove);
			//this.stage.addEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
			
		}
		
		private function ItemDown(e:MouseEvent):void
		{
			trace("e.target.parent " + e.target.parent.name);
			var acessor:AcessorioDrag = (e.target.parent is AcessorioDrag) ? (e.target.parent as AcessorioDrag) : (e.target.parent.parent as AcessorioDrag);
			
			draggingTarget = acessor;
			draggingTarget.startDrag(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
		}
		
		private function StgMouseUp(e:MouseEvent):void
		{
			var acessorio:AcessorioDrag = draggingTarget;
			var auxX:int = stage.mouseX;
			var auxY:int = stage.mouseY;
			
			acessorio.stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, StgMouseUp);
			
			if ((auxX - (acessorio.width/2) > Boneco.x) && (auxX + (acessorio.width/2) < Boneco.x + Constantes.InfoBoneco.width) &&
				(auxY - (acessorio.height/2) > Boneco.y) && (auxY + (acessorio.height/2) < Boneco.y + Constantes.InfoBoneco.height))
				{
					trace("dentro " + acessorio.name);
					
					CallbackAcessorios(acessorio);
				}
				// Checa se é um boné
				else if (acessorio is AcessorioCabelo)
				{
					var margem:uint = 10;
					
					if ((acessorio.currentFrame == 3) || (acessorio.currentFrame == 4) || 
						(acessorio.currentFrame == 5) || (acessorio.currentFrame == 9) || (acessorio.currentFrame == 11))
						{
							if ((auxX > Boneco.x - margem) && (auxX < Boneco.x + Constantes.InfoBoneco.width + margem) &&
							(auxY > Boneco.y - margem) && (auxY < Boneco.y + Constantes.InfoBoneco.height + margem))
							{
								trace("bone dentro! " + acessorio.name);
								
								acessorio.x = 78;
								acessorio.y = 34;
								CallbackAcessorios(acessorio);
							}
							else
							{
								trace("fora");
								acessorio.gotoAndStop(acessorio.totalFrames);
							}
						}
						else
						{
							trace("fora");
							acessorio.gotoAndStop(acessorio.totalFrames);
						}
				}
				else
				{
					draggingTarget.gotoAndStop(draggingTarget.totalFrames);
				}
				
				draggingTarget = null;
		}
		
		private function DragStop(e:MouseEvent):void
		{
			var acessorio:BoxAcessorios.DragableItem = (e.target.parent is BoxAcessorios.DragableItem) ? (e.target.parent as BoxAcessorios.DragableItem) : (e.target.parent.parent as BoxAcessorios.DragableItem);
			var auxX:int = acessorio.x;
			var auxY:int = acessorio.y;
			
			acessorio.stopDrag();
			acessorio.VoltarPosicao();
			
			if ((auxX > Boneco.x) && (auxX < Boneco.x + Boneco.width) &&
				(auxY > Boneco.y) && (auxY < Boneco.y + Boneco.height))
				{
					var i:uint;
					
					for (i = 1; i <= 5; ++i)
					{
						if (acessorio is (getDefinitionByName("Oculos"+i) as Class))
						{
							Boneco.oculos.gotoAndStop(i);
							Boneco.oculos.FrameChanged();
							CallbackAcessorios(Boneco.oculos);
						}
					}
					for (i = 1; i <= 11; ++i)
					{
						if (acessorio is (getDefinitionByName("Cabelo"+i) as Class))
						{
							Boneco.acessorio.gotoAndStop(i);
							Boneco.acessorio.FrameChanged();
							CallbackAcessorios(Boneco.acessorio);
						}
					}
					for (i = 1; i <= 1; ++i)
					{
						if (acessorio is (getDefinitionByName("Extra"+i) as Class))
						{
							Boneco.extra.gotoAndStop(i);
							Boneco.extra.FrameChanged();
						}
					}
				}
		}
		
		/**
		* Adiciona eventos da customização do boneco
		* @author Carvalho
		*/
		private function AddBonecoEventos():void
		{
			AddEventosPart(Boneco.cabelo);
			AddEventosPart(Boneco.boca);
			AddEventosPart(Boneco.corpo);
			AddEventosPart(Boneco.maos);
			AddEventosPart(Boneco.bochecha);
			AddEventosPart(Boneco.olho);
			
			//Boneco.acessorio.addEventListener(MouseEvent.CLICK, acessorioListener);
			//Boneco.oculos.addEventListener(MouseEvent.CLICK, acessorioListener);
		}
		
		private function acessorioListener(e:MouseEvent):void
		{
			var accessorio:AcessorioDrag = (e.target is AcessorioDrag) ? (e.target as AcessorioDrag) : (e.target.parent as AcessorioDrag);
			CallbackAcessorios(accessorio);
		}
		
		private function CallbackAcessorios(acess:AcessorioDrag):void
		{
			if (montadorTarget)
				montadorTarget.filters = [];
			
			SetaDir.visible = SetaEsq.visible = false;
			caixaCores.visible = true;
			
			paletaCabelo.visible = false;
			paletaCorpo.visible = false;
			paletaOlho.visible = false;
			paletaMaos.visible = false;
			paletaBochecha.visible = false;
			paletaAcessorio.visible = false;
			paletaOculos.visible = false;
			paletaBoca.visible = false;
			
			montadorTarget = acess;
			montadorTarget.filters = filtroGlow;
			
			if (montadorTarget is Oculos)
			{
				paletaOculos.visible = true;
			}
			else if (montadorTarget is AcessorioCabelo)
				paletaAcessorio.visible = true;
		}
		
		/**
		* Adiciona eventos da customização do boneco do parametro recebido
		* @author Carvalho
		*/
		private function AddEventosPart(part:AvatarPart):void
		{
			part.buttonMode = true;
			part.mouseEnabled = true;
			part.addEventListener(MouseEvent.MOUSE_OVER, ItemOver);
			part.addEventListener(MouseEvent.MOUSE_OUT, ItemOut);
			part.addEventListener(MouseEvent.CLICK, Click);
		}
		
		/**
		* Remove eventos da customização do boneco
		* @author Carvalho
		*/
		private function RemoveBonecoEventos():void
		{
			RemoveEventosPart(Boneco.cabelo);
			RemoveEventosPart(Boneco.corpo);
			RemoveEventosPart(Boneco.boca);
			RemoveEventosPart(Boneco.maos);
			RemoveEventosPart(Boneco.bochecha);
			RemoveEventosPart(Boneco.olho);
		}
		
		/**
		* Remove eventos da customização do boneco do parametro recebido
		* @author Carvalho
		*/
		private function RemoveEventosPart(part:AvatarPart):void
		{
			part.buttonMode = false;
			part.mouseEnabled = false;
			part.removeEventListener(MouseEvent.MOUSE_OVER, ItemOver);
			part.removeEventListener(MouseEvent.MOUSE_OUT, ItemOut);
			part.removeEventListener(MouseEvent.CLICK, Click);
		}
		
		/**
		* Callback dos botões avançar e retroceder do montador
		* @author Carvalho
		*/
		private function Click(e:MouseEvent):void
		{
			SetaDir.visible = SetaEsq.visible = true;
			caixaCores.visible = true;
			
			paletaCabelo.visible = false;
			paletaCorpo.visible = false;
			paletaOlho.visible = false;
			paletaMaos.visible = false;
			paletaAcessorio.visible = false;
			paletaBochecha.visible = false;
			paletaOculos.visible = false;
			paletaBoca.visible = false;
			
			if (SetaDir.hasEventListener(MouseEvent.CLICK) && montadorTarget)
			{
				SetaDir.removeEventListener(MouseEvent.CLICK, montadorTarget.NextEvent);
				SetaEsq.removeEventListener(MouseEvent.CLICK, montadorTarget.PrevEvent);
			}
			
			if (montadorTarget)
				montadorTarget.filters = [];
				
			montadorTarget = (e.target is AvatarPart) ? (e.target as AvatarPart) : (e.target.parent as AvatarPart);
			montadorTarget.filters = filtroGlow;
			
			switch (montadorTarget.name)
			{
				case "olho":
					paletaOlho.visible = true;
					break;
				case "cabelo":
					paletaCabelo.visible = true;
					break;
				case "maos":
					paletaMaos.visible = true;
					break;
				case "bochecha":
					paletaBochecha.visible = true;
					break;
				case "corpo":
					SetaDir.visible = SetaEsq.visible = false;
					paletaCorpo.visible = true;
					break;
				case "boca":
					paletaBoca.visible = true;
					break;
				case "oculos":
					paletaOculos.visible = true;
					break;
			}
			
			SetaDir.addEventListener(MouseEvent.CLICK, montadorTarget.NextEvent);
			SetaEsq.addEventListener(MouseEvent.CLICK, montadorTarget.PrevEvent);
			
			//Move as setas para o lado da parte clicada
			SetaDir.y = montadorTarget.y + Boneco.y + (montadorTarget.height / 2);
			SetaEsq.y = montadorTarget.y + Boneco.y + (montadorTarget.height / 2);
		}
		
		private function CenarioVoltarListener(e:MouseEvent):void
		{
			this.addChild(Boneco);
			GoToMontador(true);
		}
		
		private function ResultVoltarListener(e:MouseEvent):void
		{
			composto.removeChild(balao);
			GoToBalao();
		}
		
		/**
		* Botão que completa a montagem do boneco
		* @author Galindo
		*/
		private function ResultOKListener(e:MouseEvent):void
		{
			GoToFinal();
		}
		
		/**
		* Botão que completa a montagem do boneco
		* @author Galindo
		*/
		private function montadorOKListener(e:MouseEvent):void
		{
			SalvarAvatar();
			
			if (montadorTarget)
				montadorTarget.filters = [];
			ImgAvatar = GetAvatar();
			ImgThumb = GetAvatar(0.38); // Passa o parametro de scale para obter a imagem redimensionada para o thumbnail
			SalvarThumb();
			
			removeChild(paletaCabelo);
			removeChild(paletaCorpo);
			removeChild(paletaOlho);
			removeChild(paletaAcessorio);
			removeChild(paletaMaos);
			removeChild(paletaBochecha);
			removeChild(paletaBoca);
			removeChild(paletaOculos);
			
			RemoveBonecoEventos();
			
			Boneco.Desenhos = boxDesenho.Desenhos;
			
			goToCenario();
		}
		
		/**
		* Botão que completa a escolha do cenário
		* @author Galindo
		*/
		private function cenarioOKListener(e:MouseEvent):void
		{
			ImgCapa = GetBackground();
			GoToBalao();
		}
		
		private function btnFecharListener(e:MouseEvent):void
		{
			Boneco = new MCBoneco();
			RandomizaBoneco();
			GoToMontador();
		}
		
		/**
		* Evento do botão 'Ok', para salvar a imagem de capa com balão e o avatar na forma de 'thumb'
		* @author Carvalho
		*/
		private function BalaoOKListener(e:MouseEvent):void
		{			
			// Se não digitou nada, poe o texto padrão
			if (balao.texto.text == Constantes.TextoInicial)
				balao.texto.text = Constantes.TextoAutomatico;
		
			var mtx:Matrix =  new Matrix(1.3, 0, 0, 1.3);
			var posBalaoX:Number = 200;
			var posBalaoY:Number = 120;
			mtx.translate(posBalaoX,posBalaoY);
			ImgComposta = GetComposta();
			ImgCapa.draw(balao,mtx); // Adiciona o balão na capa da timeline
			
			btnOKBalao.enabled = false;
			
			//SalvarThumb();
			SalvarEmotigum();
				
			GoToResultado();
		}
		
		private function BalaoVoltarListener(e:MouseEvent):void
		{
			this.addChild(Boneco);
			composto.removeChild(balao);
			goToCenario();
		}
		
		private function TextoBalaoClick(e:MouseEvent):void
		{
			if (balao.texto.text == Constantes.TextoInicial)
				balao.texto.text = "";
		}
		
		private function SaveAvatarListener(e:MouseEvent):void
		{
			Publish(PNGEncoder.encode(ImgAvatar),PhotoCallback,"Meu novo Emotigum-me!");
			tarjaLoading.Adiciona(this,"Salvando avatar...");
		}
		
		private function SaveCapaListener(e:MouseEvent):void
		{
			Publish(PNGEncoder.encode(ImgCapa),PhotoCallback,"Minha nova capa da linha do tempo!");
			tarjaLoading.Adiciona(this,"Salvando capa...");
		}
		
		private function CompartilharListener(e:MouseEvent):void
		{
			Publish(PNGEncoder.encode(ImgComposta));
			
			tarjaLoading.Adiciona(this,"Compartilhando...");
			
			/*var method:String = "feed";
			var objData:Object = {
				message: "Eu entrei na máquina de Chiclets e virei esse Emotigum! Não ficou demais?",
				picture: CANVAS_URL + "/thumb/" + FacebookUID + "_thumb.png",
				link: "apps.facebook.com/emotigum-me",
				name: "Clique e faça um Emotigum com a sua cara.",
				caption: "Meu Emotigum!",
				description: "Com o Emotigum Me todo mundo vai entrar nessa! Corra e faça o seu!"
			};
			Facebook.ui(method, objData);*/
		}
		
		private var TVClick:uint = 0;
		private function ClickTV(e:MouseEvent):void
		{
			++TVClick;
			trace("clicou " + TVClick);
			if (TVClick == 50)
			{
				tulio.visible = true;
			}
		}
	}
}
