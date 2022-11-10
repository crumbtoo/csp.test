#! /usr/bin/env python3

from profanityfilter import ProfanityFilter
import sys

pf = ProfanityFilter(no_word_boundaries = True)

s = sys.stdin.read()
print(pf.censor(s))
