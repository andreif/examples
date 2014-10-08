# coding=utf-8
import re


class BaseParser(object):
    def __init__(self, source):
        self.c = source
        self.pos = 0
        self.ast = []

    def parse(self):
        return self.parse_grammar(self.grammar())

    def grammar(self):
        return []

    def append(self, tree):
        self.ast.append(tree)

    def parse_grammar(self, grammar):
        try:
            grammar = [self.eof] + grammar + [self.not_implemented]
            while 1:
                for f in grammar:
                    r = f()
                    if r:
                        print self.__class__.__name__, r
                        self.append(r)
                        break
        except EOFError:
            pass
        except NotImplementedError as e:
            print repr(e), self.__class__.__name__
            # import traceback
            # traceback.print_exc()
        return self.ast

    def not_implemented(self):
        raise NotImplementedError(repr(self.until('\n')))

    def startswith(self, *sub):
        return any([self.curr(len(s)) == s for s in sub])

    def startswith_re(self, ex):
        return re.match('^' + ex, self.rest(False))

    def newline(self):
        return self.prevswith('\n') or self.pos == 0

    def linestartswith(self, sub):
        # TODO skip whitespace
        return self.startswith(sub) and self.newline()

    def linestartswith_re(self, ex):
        # TODO skip whitespace
        return self.startswith_re(ex) and self.newline()

    def inc(self, n=1):
        if isinstance(n, str):
            n = len(n)
        s = self.curr(n)
        self.pos += n
        self.eof()
        return s

    def eof(self, n=0):
        if self.pos + n >= len(self.c):
            raise EOFError

    def curr(self, n=1):
        return self.c[self.pos:self.pos + n]

    def skip_whitespace(self):
        ws = ''
        while self.startswith(' ', '\t', '\n'):
            ws += self.inc()
        if ws:
            return ('whitespace', ws)

    def rest(self, move=True):
        s = self.c[self.pos:]
        if move:
            self.pos = len(self.c)
        return s

    def until(self, end, inclusive=True):
        i = self.c.find(end, self.pos)
        if i:
            return self.inc(i - self.pos + (len(end) if inclusive else 0))
        else:
            return self.rest()

    def until_semicolon(self):
        return self.until(';')

    def rest_line(self):
        return self.until('\n')

    def prev(self, n=1):
        return self.c[self.pos - n:self.pos]

    def prevswith(self, sub):
        return self.prev(len(sub)) == sub

    def parse_with(self, cls):
        p = cls(source=self.rest(move=False))
        ast = p.parse()
        self.inc(p.pos)
        return ast


class CommonParser(BaseParser):

    def grammar(self):
        return self.grammar_common()

    def grammar_common(self):
        return [
            self.skip_whitespace,
            self.parse_single_comment,
            self.parse_multi_comment,
        ]

    def parse_single_comment(self):
        if self.startswith('//'):
            return ('comment', self.rest_line())

    def parse_multi_comment(self):
        if self.startswith('/*'):
            return ('comment', self.until('*/', inclusive=True))


class StartEndParser(CommonParser):
    done = False

    def append(self, tree):
        super(StartEndParser, self).append(tree)
        if self.done:
            raise EOFError

    def parse_end(self):
        if self.linestartswith('@end'):
            self.done = True
            return ('end', self.rest_line())


class InterfaceParser(StartEndParser):

    def grammar(self):
        return super(InterfaceParser, self).grammar() + self.grammar_interface()

    def grammar_interface(self):
        return [
            self.parse_start,
            self.parse_end,
            self.parse_property,
        ]

    def parse_start(self):
        if self.linestartswith('@interface'):
            return ('interface', self.rest_line())

    def parse_property(self):
        if self.linestartswith('@property '):
            return ('property', self.until_semicolon())


class AssignParser(BaseParser):
    def grammar(self):
        return self.grammar_assign()

    def grammar_assign(self):
        return [
            self.skip_whitespace,
            self.parse_start,
            self.parse_call,
        ]

    def parse_start(self):
        if self.startswith_re('\w+\s*='):
            return ('assign-to', self.until('='))

    def parse_call(self):
        if self.startswith('['):
            return ('call', self.parse_with(CallParser))


class CallParser(BaseParser):
    def grammar(self):
        return self.grammar_call()

    def grammar_call(self):
        return [
            self.skip_whitespace,
            self.parse_start,
        ]

    def parse_start(self):
        if self.startswith('['):
            r = [('call-start', self.inc())]
            ws = self.skip_whitespace()
            if ws:
                r += [ws]

            return ('start')



class MethodParser(CommonParser):
    def grammar(self):
        return super(MethodParser, self).grammar() + self.grammar_method()

    def grammar_method(self):
        return [
            self.parse_start,
            self.parse_closure,
        ]

    def parse_start(self):
        if self.linestartswith_re(r'[-+]\s*\('):
            # TODO it may have no closure
            return ('method', self.until('{', False))

    def parse_closure(self):
        if self.startswith('{'):
            return ('closure', self.parse_with(ClosureParser))


class IfExpParser(CommonParser):
    def grammar(self):
        return super(IfExpParser, self).grammar() + self.grammar_if()

    def grammar_if(self):
        return [
            self.parse_start,
        ]

    def parse_start(self):
        if self.linestartswith('@implementation'):
            return ('implementation', self.rest_line())


class ClosureParser(CommonParser):
    done = False

    def grammar(self):
        return super(ClosureParser, self).grammar() + self.grammar_closure()

    def grammar_closure(self):
        return [
            self.parse_start,
            self.parse_assign,
            self.parse_end,
        ]

    def parse_start(self):
        if self.startswith('{'):
            return ('closure-start', self.inc())

    def parse_end(self):
        if self.startswith('}'):
            self.done = True
            return ('closure-end', self.inc())

    def parse_assign(self):
        if self.startswith_re('\w+\s*='):
            return ('assign', self.parse_with(AssignParser))


class ImplementationParser(StartEndParser):

    def grammar(self):
        return super(ImplementationParser, self).grammar() + self.grammar_implementation()

    def grammar_implementation(self):
        return [
            self.parse_start,
            self.parse_end,
            self.parse_synthesize,
            self.parse_method,
        ]

    def parse_start(self):
        if self.linestartswith('@implementation'):
            return ('implementation', self.rest_line())

    def parse_synthesize(self):
        if self.linestartswith('@synthesize '):
            return ('synthesize', self.until_semicolon())

    def parse_method(self):
        if self.linestartswith_re(r'[-+]\s*\('):
            return ('method', self.parse_with(MethodParser))


class FileParser(CommonParser):

    def grammar(self):
        return super(FileParser, self).grammar() + self.grammar_file()

    def grammar_file(self):
        return [
            self.parse_import,
            self.parse_interface,
            self.parse_implementation,
        ]

    def parse_import(self):
        if self.linestartswith('#import'):
            return ('import', self.rest_line())

    def parse_interface(self):
        if self.linestartswith('@interface'):
            return ('interface', self.parse_with(InterfaceParser))

    def parse_implementation(self):
        if self.linestartswith('@implementation'):
            return ('implementation', self.parse_with(ImplementationParser))


h = open('motion/motion/RootViewController.h').read()
m = open('motion/motion/RootViewController.m').read()
FileParser(source=h + '\n' + m).parse()
