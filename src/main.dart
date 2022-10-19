import "dart:html";

void postbutton_click(Event e)
{
	print("down");
}

int main()
{
	final Element? postbutton = querySelector("#postbutton");

	postbutton!.onClick.listen(postbutton_click);

	return 0;
}

