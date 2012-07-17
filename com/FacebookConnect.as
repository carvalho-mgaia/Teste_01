package
{
	import flash.system.Security;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookAuthResponse;
	//import com.facebook.graph.data.FacebookSession;
	import com.adobe.serialization.json.JSON;
	import flash.events.EventDispatcher;
	
	
	/**
	* Classe de conexão com o Facebook, responsável pela comunicação, permissões, etc.
	* Obs.: Deve estar incluído, na configuração do arquivo principal do projeto, o link
	*		para a biblioteca "GraphAPI_Web_1_8_1.swc" (ex: ./com/API/GraphAPI_Web_1_8_1.swc).
	*		Ver "ActionScript Settings" -> "Library Path".
	* @author Galindo
	*/
	public class FacebookConnect extends EventDispatcher
	{
		private var APP_ID:String;
		private var CANVAS_URL:String;
		private var APP_URL:String;
		private var SCOPE:Array = [];
		
		//private var _fbSession:FacebookSession = null;
		private var _fbAuthResponse:FacebookAuthResponse = null;
		private var _uid:String = "";
		
		static public const GET:String = "GET";
		static public const POST:String = "POST";
		
		
		/**
		* Construtor da classe, não recebe parâmetros.
		* @author Galindo
		*/
		public function FacebookConnect(appId:String=null, canvasUrl:String=null, appUrl:String=null, scope:Array=null)
		{
			Config(appId, canvasUrl, appUrl, scope);
		}
		
		/**
		* Configura os parâmetros para conexão com o Facebook.
		* @author Galindo
		*/
		public function Config(appId:String=null, canvasUrl:String=null, appUrl:String=null, scope:Array=null):void
		{
			// Atribui os valores, caso sejam passados
			if(appId)
			{
				APP_ID = appId;
			}
			
			if(canvasUrl)
			{
				CANVAS_URL = canvasUrl;
			}
			
			if(appUrl)
			{
				APP_URL = appUrl;
			}
			
			if(scope)
			{
				SCOPE = scope;
			}
		}
		
		/**
		* Retorna o Id do aplicativo no facebook.
		* @author Galindo
		*/
		public function get AppId():String
		{
			return APP_ID;
		}
		
		/**
		* Retorna a Url do canvas do aplicativo.
		* @author Galindo
		*/
		public function get CanvasUrl():String
		{
			return CANVAS_URL;
		}
		
		/**
		* Retorna a Url 'https' utilizada pelo aplicativo.
		* @author Galindo
		*/
		public function get AppUrl():String
		{
			return APP_URL;
		}
		
		/**
		* Retorna o escopo de permissões do aplicativo
		* @author Galindo
		*/
		public function get Scope():Array
		{
			return SCOPE;
		}
		
		/**
		* Retorna a ID do usuário no Facebook.
		* @author Galindo
		*/
		public function get Uid():String
		{
			return _uid;
		}
		
		/**
		* Retorna o objeto de autorização do facebook.
		* @author Galindo
		*/
		public function get FBAuthResponse():FacebookAuthResponse
		{
			return _fbAuthResponse;
		}
		
		/**
		* Retorna o objeto contendo a sessão do facebook.
		* @author Galindo
		*/
		/*public function get FBSession():FacebookSession
		{
			return _fbSession;
		}*/
		
		
		/**
		* Inicializa os processos de conexão e autorização com o Facebook. Deve ser chamado primeiro.
		* Obs.: callback é livre, pois o callback original da função "callback(success:Object, fail:Object)",
		*		está sendo utilizado em 'OnFacebookInit' dessa classe.
		*		O retorno da inicialização será feito no 'FBAuthResponse'. (ver: OnFacebookInit). Ao contrário
		*		do que diz a documentação, o 'FacebookSession' *NÃO* é retornado.
		* @author Galindo
		*/
		private var CallBack_Init:Function = null;
		private var CallBack_Erro:Function = null;
		public function Init(callback:Function=null, callbackErro:Function=null, options:Object=null, accessToken:String=null):void
		{
			// Configurações de segurança
			Security.allowDomain("*");
			Security.loadPolicyFile("http://api.facebook.com/crossdomain.xml");
			
			CallBack_Init = callback;
			CallBack_Erro = callbackErro;
			
			// Inicia as configurações do facebook
			Facebook.init(APP_ID, OnFacebookInit, options, accessToken);
		}
		
		/**
		* Chamado quando a inicialização com o facebook é completada.
		* O sucesso na conexão retorna um objeto do tipo 'FacebookAuthResponse'.
		* @author Galindo
		*/
		private function OnFacebookInit(success:FacebookAuthResponse, fail:Object):void
		{
			if(success)
			{
				_fbAuthResponse = success;
				_uid = _fbAuthResponse.uid;
				
				// Executa o callback
				if(CallBack_Init != null)
				{
					CallBack_Init();
				}
			}
			else if(fail)
			{
				// Executa o callback de erro
				if(CallBack_Erro != null)
				{
					CallBack_Erro();
				}
			}
			else
			{
				navigateToURL(this.GetAuthURL, "_top");
			}
		}
		
		/**
		* Retorna a URL de autorização do Facebook, baseada no "OAuth 2.0"
		* @author Galindo
		*/
		private var DefaultUrl:String = "https://www.facebook.com/dialog/oauth?client_id=";
		public function get GetAuthURL():URLRequest
		{
			var scopeParams:String = "";
			if(SCOPE.length)
			{
				scopeParams = "&scope=" + SCOPE.join(",");
			}
			
			return new URLRequest(
				DefaultUrl + APP_ID	+ "&redirect_uri=" + APP_URL + scopeParams
			);
		}
		
		/**
		* Faz uma nova requisição para a Facebook Graph API.
		* Obs.: callback(result:Object, fail:Object)
		*		requestMethod: '(...) used to send values to Facebook. The graph API
		*		follows correct Request method conventions. GET will return data from
		*		Facebook. POST will send data to Facebook.'
		* @author Galindo
		*/
		public function Api(method:String, callback:Function=null, params:*=null, requestMethod:String="GET"):void
		{
			Facebook.api(method, callback, params, requestMethod);
		}
		
		/**
		* Faz uma requisição a janela de compartilhamento do Facebook.
		* @author Galindo
		*/
		public function Ui(method:String, data:Object, callback:Function=null, display:String=null):void
		{
			Facebook.ui(method, data, callback, display);
		}
		
	}
}