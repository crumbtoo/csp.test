import "dart:html";
import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import "dart:io";
import 'dart:web_audio';
import "package:http/http.dart" as http;

import "helpers.dart";
import "catppuccin.dart";

void message(Element? e, String bgcolor, String fgcolor, String text) async
{
	if(e == null)
		return;

	final errw = DivElement();
	errw.classes.add("comment-wrapper");
	errw.style.backgroundColor = bgcolor;
	errw.style.textAlign = "center";

	final errt = ParagraphElement();
	errt.style.fontFamily = '"Hack", "Source Code Pro", monospace';
	errt.style.color = fgcolor;
	errt.style.fontSize = "13px";
	errt.innerText = text;

	errw.children.add(errt);
	e.parent!.children.add(errw);
	await Future.delayed(Duration(seconds: 2));
	errw.remove();
}

Future<http.Response> postcomment(String? alias, String? comment) async
{
	String url = "http://puppy.tf/newpost";
	/* String url = "http://puppy.tf/cgi/dump"; */
	Map<String, String> headers = new HashMap();
	headers["Accept"] = "application/json";
	headers["Content-type"] = "application/json";
	String jsonbody = jsonEncode(
	{
		"timestamp": DateTime.now().millisecondsSinceEpoch,
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

void postbutton_click(Event e) async
{
	TextInputElement? alias = querySelector("#text-alias-input") as TextInputElement;
	TextAreaElement? comment = querySelector("#text-comment-input") as TextAreaElement;


	print("alias: ${alias.value}");
	print("comment: ${comment.value}");


	if(isPseudoEmpty(alias.value) || isPseudoEmpty(comment.value))
		message(alias.parent, "var(--cat-red)", "var(--cat-crust)", "you know what you've done wrong :(");
	else
	{
		http.Response r = await postcomment(alias.value, comment.value);

	    print('Response status: ${r.statusCode}');
		print('Response body: ${r.body}');

		if(r.statusCode == 200)
		{
			message(alias.parent, "var(--cat-green)", "var(--cat-crust)", "it's on her way love");
			await Future.delayed(Duration(seconds: 3));
			/* reload(); */
			window.location.assign(window.location.href);
		}
	}
}

int main()
{
	final Element? postbutton = querySelector("#postbutton");

	postbutton!.onClick.listen(postbutton_click);

	return 0;
}

