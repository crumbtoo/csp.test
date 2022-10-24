import "dart:html";
import "dart:convert";
import 'package:http/http.dart' as http;
import "helpers.dart";

Future<http.Response?> newpost(String? alias, String? comment) async
{
	if(alias == null || comment == null)
		return null;

	return http.post(
        Uri.parse('http://csp.test/newpost'),
        headers: <String, String>{
            'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
            'alias': alias,
            'comment': comment
        }),
    );
}

void postbutton_click(Event e) async
{
	TextInputElement alias_e = querySelector("#text-alias-input")
		as TextInputElement;
	TextAreaElement comment_e = querySelector("#text-comment-input")
		as TextAreaElement;
	print("alias: ${alias_e.value}");
	print("comment: ${comment_e.value}");


	if(isPseudoEmpty(comment_e.value) || isPseudoEmpty(alias_e.value))
	{
		message(alias_e.parent!.parent, "var(--cat-red)", "var(--cat-crust)",
			"you know what you've done");
	}
	else
	{
		http.Response? r = await newpost(alias_e.value, comment_e.value);

		if(r == null)
		{
			message(alias_e.parent!.parent, "var(--cat-red)",
			"var(--cat-crust)", "uhhh");
			return;
		}

		print("resp: ${r.body}");

		message(alias_e.parent!.parent, "var(--cat-green)",
			"var(--cat-crust)", "it's on her way...");
	}
}

int main()
{
	final Element? postbutton = querySelector("#postbutton");

	postbutton!.onClick.listen(postbutton_click);

	return 0;
}

