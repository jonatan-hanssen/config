; extends
; Inject java into triple-quoted strings that start with 'java\n'
((string_content) @injection.content
  (#match? @injection.content "^java\n")
  (#set! injection.language "java")
  (#set! injection.include-children false))
