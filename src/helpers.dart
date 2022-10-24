import "dart:html";

bool isPseudoEmpty(String? s)
{
	if(s == null || s.length == 0)
		return true;

	for(int i = 0; i < s.length; i++)
	{
		if(s[i] != ' '
		&& s[i] != '\t'
		&& s[i] != '\n'
		&& s[i] != '\r')
			return false;
	}

	return true;
}

void message(Element? parent, String bg, String fg, String s) async
{
	final Element msg = DivElement();

	if(parent == null)
	{
		/* dart's shit static analysis wont let me use
		 * `if((parent = querySelector("body")) == null)` */

		parent = querySelector("body");
		if(parent == null)
			return;
	}
	/* else */
	/* 	msg.style.width = "100%"; */

	msg.innerText = s;
	msg.classes.add("message");
	msg.style.backgroundColor = bg;
	msg.style.color = fg;

	parent.children.add(msg);

	await Future.delayed(Duration(seconds: 3));

	msg.remove();
}
