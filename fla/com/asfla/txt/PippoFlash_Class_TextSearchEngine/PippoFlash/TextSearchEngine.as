/* WWW.PIPPOFLASH.COM - TextSearchEngine

PippoFlash.TextSearchEngine
	Searches a text in a string. If a textField is inputed as parametr, the search is made in text in the textfield, and found keys are highlighted.
	TextFormats for plain text and results can be set. Search can be case sensitive or non case sensitive.
	A list of forbidden search terms and forbidden characters can be set.

VERSION
	1.0

LAST UNIVERSAL VERSION
	1.0

TYPE
	Static Class - Flash Player 8 onward - AS 2.0
	
HELPERS
	no helpers

RETURNS
	nothing

USAGE
	result = TextSearchEngine.findExact(paramsObj);
	
PARAMETERS
	
CLASS METHODS

	findExact();
		var result:Object = TextSearchEngine.findExact(params);
			Finds an exact string in the textfield.
			params {}
				key				S	The term to be searched (can be a single word or a phrase)
				matchCase		B	If true, the search will be case sensitive
				textField			O	The textfield where to perform the search
				foundTextFormat	O	The TextFormat to apply to word found in textfield
				mainTextFormat	O 	The textformat to reset all text (if not defined, it is retrieved from the textfield)
				text				S	If no TextField is specified, tthis string will be searched. (optional)
				excludeKeys		S	A space delimited list of words to be excluded from search if the key IS EQUAL (i.e., for html files its good to exclude: "html font color align ...")
				excludeChars		S	A space delimited list of characters and words to exclude the key if CONTAINS one of these (i.e. "! $ % & /> / > ...")
				minWordSize		N	A minimum length for search key (defaults to 3)
	Feedback
		The result returns an object.
			object {}
				found			N	The number of results found for key (if no result, is 0)
				key				S	The searched key
				positions			A	An array with the starting position of results in the searched text
				message			S	A verbose message with the result (it is also shown in the trace window)
	
	findAll();
		Looks for the exact string, and for each word in the string.
			params {} - are the same for findExact();
	Feedback
		The result returns an object.
			object {}
				found			N	The total number of occurrances
				message			S	A verbose message with the result (it is also shown in the trace window)
				results			A	An array containing an object for each search key in sentence. Each object is like feedback from findExact();
				
	setupSearchParameters();
		Sets up all default search parameters, like textFormats and excludelist, etc.
		PArams are the same for find, excluding key and textFiled (or text).
		Once setup, search can be called using onlu textField and Key.


*/
/* ANALISYS
	This function is Quick and useful to search text in textfields.

*/
/* COPYRIGHT
	
	This code has been written by Filippo Gregoretti (www.pippoflash.com).
	Free to use in non-profit projects, but ask for my permission please.
	Not to be used in commercial projects without my written approval, and not for resale.
	Filippo Gregoretti - pippo@pippoflash.com
	
*/



// START CLASS
class PippoFlash.TextSearchEngine {
// /////////////////////////////////////////////////////////////////////////////////////
// PROPERTIES ///////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////////////

	// USER PARAMETERS	
	static var minWordSize		:Number		= 3; // The minimum length of search keys
	static var messages		:Object		= {ok:"<Y> - ",ko:"<N> - ",excludedChar:" contains a forbidder character: ",excludedKey:" is excluded from search.", notFound:" not found.",searching:"Searching: ",tooShort:" is not long enough.",found1:" found ",found2:" times.",returned1:" returned ",returned2:" results."}; // System messages
	static var excludeKeys		:Object;		// Contains the EXACT WORDS to exclude
	static var excludeChars	:Object;		// Contains the characters, or group of characters, to exclude
	static var searchKey		:String;		// Stores the search key
	static var searchText		:String;		// Stores the whole text
	static var mainTextFormat	:TextFormat;	// The original text format
	static var foundTextFormat	:TextFormat;	// The found text format
	static var userParams		:Object;

// ////////////////////////////////////////////////////////////////////////////////////
// METHODS ////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////////////////
	static function findExact				(params:Object) : Object {
		setupSearchParameters				(params);
		params.textField.setTextFormat		(mainTextFormat);
		return						find(searchKey, searchText);
	}

	static function findAll					(params:Object) : Object {
		var completeSentence				= params.key;
		setupSearchParameters				(params);
		params.textField.setTextFormat	(mainTextFormat);
		var obj						= {found:0,message:"",results:[]};
		// Search each word
		var searchList					= searchKey.split(" ");
		if (searchList.length > 1) {
			for (var i in searchList) {
				userParams.key				= searchList[i];
				setupSearchParameters			(userParams);
				obj.results.push				(find(searchKey, searchText));
				obj.found					+= obj.results[obj.results.length-1].found;
				obj.message				+= " | " + obj.results[obj.results.length-1].message;
			}
		}
		var summary					= ("\""+completeSentence+"\"" + messages.returned1 + obj.found + messages.returned2);
		trace							(summary);
		obj.message					+= " | " + summary;
		return						obj;
	}

	static function setupSearchParameters		(params:Object) : Void {
		// Setup static values
		userParams						= params;
		var t							= params.textField ? params.textField.text : params.text;
		searchText						= params.matchCase ? t : t.toLowerCase();
		searchKey						= params.matchCase ? params.key : params.key.toLowerCase();
		mainTextFormat					= params.mainTextFormat ? params.mainTextFormat : mainTextFormat ? mainTextFormat : params.textField.getTextFormat();
		foundTextFormat					= params.foundTextFormat ? params.foundTextFormat : foundTextFormat;
		if (!foundTextFormat) 				foundTextFormat = new TextFormat(null, null, 0xff0000);
		if (params.minWordSize)			minWordSize = params.minWordSize;
		setupExcludeObject				("excludeKeys");
		setupExcludeObject				("excludeChars");
	}
	
// ////////////////////////////////////////////////////////////////////////////////////
// UTILITIES ////////////////////////////////////////////////////////////////////////////
// ////////////////////////////////////////////////////////////////////////////////////
	
	private static function setupExcludeObject	(val:String) : Void {
		TextSearchEngine[val]				= new Object();
		var link						= TextSearchEngine[val];
		var a							= userParams[val].split(" ");
		for (var i in a) {
			link[a[i]] = true;
		}
	}

	private static function find				(key:String, searched:String):Object {
		// Setup excluded chars
		var excludedCharFound;
		for (var i in excludeChars)			if (key.indexOf(i) != -1) excludedCharFound = i;
		var myKey						= "\""+key+"\"";
		var obj						= {key:key, found:0};
		if (key.length < minWordSize)		obj.message = messages.ko + myKey + messages.tooShort;
		else if (excludedCharFound)			obj.message = messages.ko + myKey + messages.excludedChar + "\"" + excludedCharFound + "\".";
		else if (excludeKeys[key])			obj.message = messages.ko + myKey + messages.excludedKey;
		else {
			var cut					= searched.split(key);
			if (cut.length > 1) {
				obj.message			= (messages.ok + myKey + messages.found1 + (cut.length-1) + messages.found2);
				obj.positions			= new Array();
				var step				= 0;
				for (var i=0; i<cut.length; i++){
					obj.positions.push	(cut[i].length+step);
					userParams.textField.setTextFormat(cut[i].length+step, cut[i].length+step+key.length, foundTextFormat);
					step				+= cut[i].length + key.length;
				}
				obj.found				= obj.positions.length-1;
			}
			else						obj.message = messages.ko + myKey + messages.notFound;
		}
		trace							(obj.message);
		return						obj;
	}
}

















