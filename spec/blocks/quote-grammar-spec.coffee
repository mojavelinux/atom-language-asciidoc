describe 'Should tokenizes quote block when', ->
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

  it 'contains simple phrase', ->
    tokens = grammar.tokenizeLines '''
      [quote, Erwin Schrödinger, Sorry]
      ____
      I don't like it, and I'm sorry I ever had anything to do with it.
      ____
      '''
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 7
    expect(tokens[0][0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[0][1]).toEqual value: 'quote', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.label.asciidoc' ]
    expect(tokens[0][2]).toEqual value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[0][3]).toEqual value: 'Erwin Schrödinger', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.attribution.asciidoc']
    expect(tokens[0][4]).toEqual value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[0][5]).toEqual value: 'Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.citetitle.asciidoc']
    expect(tokens[0][6]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '____', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: '____', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']

  it 'quote declarations with attribution', ->
    {tokens} = grammar.tokenizeLine '[verse, Homer Simpson]\n'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[1]).toEqual value: 'verse', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.label.asciidoc']
    expect(tokens[2]).toEqual value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[3]).toEqual value: 'Homer Simpson', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.attribution.asciidoc']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[5]).toEqual value: '\n', scopes: ['source.asciidoc']

  it 'quote declarations with attribution and citation', ->
    {tokens} = grammar.tokenizeLine '[quote, Erwin Schrödinger, Sorry]\n'
    expect(tokens).toHaveLength 8
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[1]).toEqual value: 'quote', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.label.asciidoc']
    expect(tokens[2]).toEqual value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[3]).toEqual value: 'Erwin Schrödinger', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.attribution.asciidoc']
    expect(tokens[4]).toEqual value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[5]).toEqual value: 'Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.citetitle.asciidoc']
    expect(tokens[6]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[7]).toEqual value: '\n', scopes: ['source.asciidoc']

  it 'with Markdown style and mix content', ->
    tokens = grammar.tokenizeLines '''
      > I've got Markdown in my AsciiDoc!
      >
      > *strong*
      > Yep. AsciiDoc and Markdown share a lot of common syntax already.
      '''
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '> ', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[0][1]).toEqual value: 'I\'ve got Markdown in my AsciiDoc!', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '>', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[2]).toHaveLength 4
    expect(tokens[2][0]).toEqual value: '> ', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[2][1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2][2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.bold.constrained.asciidoc']
    expect(tokens[2][3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: '> Yep. AsciiDoc and Markdown share a lot of common syntax already.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']

  it 'with Markdown style and multi-lines', ->
    tokens = grammar.tokenizeLines '''
      foobar
      > I don't like it, and I'm sorry I ever had anything to do with it.
      > Erwin Schrödinger, Sorry
      foobar foobar
      foobar

      foobar
      '''
    expect(tokens).toHaveLength 7
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqual value: 'foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: '> ', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[1][1]).toEqual value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: '> Erwin Schrödinger, Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: 'foobar foobar', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[4]).toHaveLength 1
    expect(tokens[4][0]).toEqual value: 'foobar', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[5]).toHaveLength 1
    expect(tokens[5][0]).toEqual value: '', scopes: ['source.asciidoc']
    expect(tokens[6]).toHaveLength 1
    expect(tokens[6][0]).toEqual value: 'foobar', scopes: ['source.asciidoc']
