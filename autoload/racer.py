import subprocess

def _parse(s):
    prefix = None
    matches = []
    for line in s.splitlines():
        if line.startswith("MATCH "):
            tokens = line[6:].split(",", 5)
            match = dict(zip(['match', 'line', 'col', 'file', 'txt'], tokens))
            matches.append(match)
        elif line.startswith("PREFIX "):
            tokens = line[7:].split(",")
            prefix = dict(zip(['start', 'end', 'match'], tokens))
        else:
            pass # ignore
    return prefix, matches 

def _run(cmd, line, col, fname):
    p = subprocess.Popen(["racer", cmd, str(line), str(col), fname], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    if p.returncode != 0:
        return None, []
    return _parse(out)

def complete(line, col, fname):
    prefix, matches = _run("complete", line, col, fname)
    if prefix == None or len(matches) == 0:
        return [0, []]
    else:
        vml = []
        for m in matches:
            vml.append(dict(word = m['match'], abbr = m['txt']))
        return [prefix['start'], vml]

def find_definition(line, col, fname):
    prefix, matches = _run("find-definition", line, col, fname)
    if len(matches) > 0:
        m = matches[0]
        return "%s:%s:%s %s" % (m['file'], m['line'], m['col'], m['txt'])
    return ""
