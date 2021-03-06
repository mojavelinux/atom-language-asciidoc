describe 'Should tokenizes footnote macro when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'simple footnote', ->
    {tokens} = grammar.tokenizeLine 'footnote:[text]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'footnote:[', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc']
    expect(tokens[1]).toEqual value: 'text', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc', 'support.constant.footnote.inline.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc']

  it 'simple footnoteref with id and text', ->
    {tokens} = grammar.tokenizeLine 'footnoteref:[id,text]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'footnoteref:[', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc']
    expect(tokens[1]).toEqual value: 'id,text', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc', 'support.constant.footnote.inline.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc']

  it 'simple footnoteref with id', ->
    {tokens} = grammar.tokenizeLine 'footnoteref:[id]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'footnoteref:[', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc']
    expect(tokens[1]).toEqual value: 'id', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc', 'support.constant.footnote.inline.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.link.footnote.asciidoc']
