package net.nateboxer.garden.utils {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import net.nateboxer.garden.plants.Plant;
	
	public class VoteUtils {

		public static const GARDEN_SOURCE:int = 0;
		public static const VOTING_BOOTH_SOURCE:int = 1;
		
		public function VoteUtils() {
		}
		
		public static function votePlant( plant:Plant, plantX:Number, plantName:String, pathPrefix:String = "", source:int = GARDEN_SOURCE ):String {
			var voteLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest( pathPrefix + "php/vote_plant.php" );
			var urlVars:URLVariables = new URLVariables();
			
			urlVars.maxAge = plant.maxAge;
			urlVars.maxPhenes = plant.maxPheneCount;
			urlVars.maxTips = plant.maxTips;
			urlVars.genes = plant.genes;
			urlVars.pDNAID = plant.parentDNAID;
			urlVars.pName = plant.parentName;
			urlVars.plantID = plant.id;
			urlVars.source = source;
			urlVars.codonRange = plant.codonRange;
			urlVars.pheneSetSize = plant.pheneSetSize;
			
			if( source == VOTING_BOOTH_SOURCE ) {
				urlVars.ignorePriorVote = 1;
			}

			if( plantX >= 0 ) {
				urlVars.userX = plantX;
			} else {
				urlVars.userX = Math.floor(Math.random() * 100000); // MUST MATCH GARDEN WIDTH ON SERVER!!!
			}
			
			// if no name given, keep parent's name
			if( plantName != "" ) {
				urlVars.name = TextUtils.cleanText( plantName );
			} else {
				urlVars.name = plant.parentName;
			}
			
			urlRequest.data = urlVars;				
			urlRequest.method = URLRequestMethod.POST;
			var errorMessage:String = "";
			try {
				voteLoader.load( urlRequest );
			} catch( e:Error ) {
				errorMessage = e.toString();
			}			
			
			return errorMessage;
		}
	}
}