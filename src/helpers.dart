import "dart:html";

/**
 * @brief test if string is null, empty, or comprised of entirely whitespace
 *
 * @param s string to test
 *
 * @returns true if string is empty, false otherwise
 */
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

/**
 * @brief returns unix time in seconds
 *
 * @returns unix time in seconds
 *
 * at least its not javascript at least its not javascript at leas
 */
int timesec()
{
	return (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
}

