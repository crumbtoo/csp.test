import "dart:html";
/* import 'dart:web_audio'; */

final Element? postbutton = querySelector("#postbutton");

void postbutton_click(Event e)
{
	/* String? alias = document.querySelector("#text-alias-input") */
	/* 	!.attributes["value"]; */
	/* String? text = document.querySelector("#text-comment-input") */
	/* 	!.attributes["value"]; */

	/* print("alias: $alias"); */
	/* print("text: $text"); */

	TextAreaElement alias_ta = querySelector("#text-alias-input") as TextAreaElement;
	String? alias = alias_ta.value;
	print("alias:");
	print(alias);
}

int main()
{
	postbutton!.onClick.listen(postbutton_click);

	return 0;
}

