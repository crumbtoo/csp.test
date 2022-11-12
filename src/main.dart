import "dart:html";
import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import "dart:io";
import 'dart:web_audio';
import "package:http/http.dart" as http;
import 'package:profanity_filter/profanity_filter.dart';

import "helpers.dart";
import "catppuccin.dart";

final proffilter = ProfanityFilter();

/**
 * @brief disable post button for 5 seconds
 */
Future<void> postbtn_cooldown() async
{
	ButtonElement? postbutton = querySelector("#postbutton")
		as ButtonElement?;

	if(postbutton == null)
		return;
	postbutton.disabled = true;
	postbutton.classes.add("disabled");

	await Future.delayed(Duration(seconds: 5));

	postbutton.classes.remove("disabled");
	postbutton.disabled = false;
}

/**
 * @brief create an alert message
 *
 * @param e sibling element for the message
 * @param bgcolour background colour for message box
 * @param fgcolour text colour for message
 * @param text message
 */
void message(Element? e, String bgcolour, String fgcolor, String text) async
{
	if(e == null)
		return;

	final errw = DivElement();
	errw.classes.add("error-wrapper");
	errw.style.backgroundColor = bgcolour;

	final errt = ParagraphElement();
	errt.style.color = fgcolor;
	errt.innerText = text;

	errw.children.add(errt);

	e.parent!.children.add(errw);

	await Future.delayed(Duration(seconds: 2));
	errw.remove();
}

/**
 * @brief wrapper to post /newpost
 *
 * @param alias commenter name
 * @param comment comment body
 *
 * @returns server response
 */
Future<http.Response> postcomment(String? alias, String? comment) async
{
	/* String url = "http://csp.test/newpost"; */
	String url = "http://puppy.tf/newpost";
	Map<String, String> headers = new HashMap();
	headers["Accept"] = "application/json";
	headers["Content-type"] = "application/json";
	String jsonbody = jsonEncode(
	{
		"timestamp": timesec(),
		"alias": alias,
		"comment": comment,
	});
	print(jsonbody);
	return http.post(
		Uri.parse(url),
		headers: headers,
		body: jsonbody,
	);
}

/**
 * @brief post button callback
 */
void postbutton_click(Event e) async
{
	TextInputElement? alias = querySelector("#text-alias-input")
		as TextInputElement;
	TextAreaElement? comment = querySelector("#text-comment-input")
		as TextAreaElement;


	print("alias: ${alias.value}");
	print("comment: ${comment.value}");


	if(isPseudoEmpty(alias.value) || isPseudoEmpty(comment.value))
		message(alias.parent, "var(--cat-red)", "var(--cat-crust)",
			"it's rude to leave an input box empty...");
	else
	{
		http.Response r = await postcomment(alias.value, comment.value);

	    print('Response status: ${r.statusCode}');
		print('Response body: ${r.body}');

		if(r.statusCode == 200)
		{
			message(alias.parent, "var(--cat-green)", "var(--cat-crust)",
				"it's on her way");

			askupdate(0);
			refresh_comments = true;
			await postbtn_cooldown();
		}
	}
}

http.Client client = http.Client();
Map<String, String> update_headers = new HashMap();

/**
 * @brief wrapper to request /askupdate
 *
 * @param time unix time in seconds to fetch all comments posted after 
 *
 * @returns server response
 */
Future<http.Response> askupdate(int time)
{
	/* String url = "http://csp.test/askupdate"; */
	String url = "http://puppy.tf/askupdate";
	String jsonbody = jsonEncode(
	{
		"timestamp": time,
	});
	print(jsonbody);
	return client.post(
		Uri.parse(url),
		headers: update_headers,
		body: jsonbody,
	);
}

/**
 * @brief add comments to the document using the json response from /askupdate
 */
void makecomments(Map<String, dynamic> json)
{
	var jcomm = json["newcomments"] as List;
	Element? commhere = querySelector("#comments-here")?.parent;

	if(commhere == null)
		return;

	for(Map<String, dynamic> e in jcomm)
	{
		print("${e['timestamp']}: ${e['alias']}: ${e['comment']}");

		DivElement comcom = new DivElement();
		DivElement comcoma = new DivElement();
		DivElement comcomc = new DivElement();
		DivElement comcomd = new DivElement();

		String alias = proffilter.censor(
			e["alias"]
			.replaceAll("@COLON@", ":"));
		String comment = proffilter.censor(
			e["comment"]
			.replaceAll("@COLON@", ":")
			.replaceAll("@NEWLINE@", "\n"));

		commhere.children.insert(0, comcom);
		comcom.classes.add("comment-comment");
		comcom.classes.add("fresh");

		comcom.children.add(comcoma);
		comcoma.classes.add("comment-comment-alias");
		comcoma.innerText = alias;

		comcom.children.add(comcomc);
		comcomc.classes.add("comment-comment-comment");
		comcomc.innerText = comment;

		comcom.children.add(comcomd);
		comcomd.classes.add("comment-comment-date");
		comcomd.innerText = e["timestamp"];

		Future.delayed(Duration(milliseconds: 700),
			() => comcom.classes.remove("fresh"));
	}
}

bool refresh_comments = false;

/**
 * @brief sleep for `delaysec` seconds, or until a refresh is manually triggered
 */
Future<void> commentsSleep(int delaysec) async
{
	int t1 = timesec();
	int until = t1 + delaysec;

	while(timesec() <= until && !refresh_comments)
		await Future.delayed(Duration(seconds: 1));
	refresh_comments = false;
}

/**
 * @brief start listening for new comments & add them to view
 */
void watchcomments() async
{
	int last_update = 0;
	update_headers["Accept"] = "application/json";
	update_headers["Content-type"] = "application/json";
	print("watchcomments()");

	while(true)
	{
		http.Response r = await askupdate(last_update);
		Map<String, dynamic> json = jsonDecode(r.body);

		if(json["timestamp"].toInt() > last_update)
			makecomments(json);

		last_update = timesec();
		await commentsSleep(15);
	}
}

int main()
{
	final Element? postbutton = querySelector("#postbutton");
	postbutton!.onClick.listen(postbutton_click);

	watchcomments();

	return 0;
}

