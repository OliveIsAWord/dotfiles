qwerty = r"""
~1234567890-=
 qwertyuiop[]\
 asdfghjkl;'
 zxcvbnm,./
""".strip()

main = r"""
`[]{}=+*()^/@
 ;,.pyfgcrl!&\
 aoeuidhtns_
 'qjkxbmwvz
""".strip()

shift = r"""
$0123456789%#
 :<>PYFGCRL?~|
 AOEUIDHTNS-
 "QJKXBMWVZ
""".strip()

modes = {"main": main, "shift": shift}
print("{");
for name, to_keys in modes.items():
    print(f"[{name}]")
    for from_key, to_key in zip(qwerty, to_keys, strict=True):
        if from_key.isspace():
            assert to_key.isspace()
            continue
        print(f'    "{from_key}" = "{to_key}";')
    print()
