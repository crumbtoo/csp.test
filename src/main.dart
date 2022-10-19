import "package:sqlite3/sqlite3.dart";
import "dart:html";

int main()
{
	querySelector("h1")!.text = "hmmm?";

	for(Element? e in querySelectorAll("h1"))
		e!.text = "lol";

	return 0;
}

