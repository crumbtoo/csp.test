bool isWhitespace(var c)
{
	if(c == ' ' || c == '\t' || c == '\n')
		return true;
	else
		return false;
}

bool isPseudoEmpty(String? s)
{
	if(s == null || s.isEmpty)
		return true;

	for(int i = 0; i < s.length; i++)
	{
		if(!isWhitespace(s[i]))
			return false;
	}
	return true;
}

