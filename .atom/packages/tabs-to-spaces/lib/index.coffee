#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TabsToSpaces = null
tabsToSpaces = null

module.exports =
  config:
    onSave:
      type: 'string'
      default: 'none'
      enum: ['none', 'tabify', 'untabify']

  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:tabify', ->
      loadModule()
      tabsToSpaces.tabify()

    atom.workspaceView.command 'tabs-to-spaces:untabify', ->
      loadModule()
      tabsToSpaces.untabify()

    atom.workspace.eachEditor (editor) ->
      handleEvents(editor)

# Internal: Sets up event handlers.
#
# editor - {Editor} to attach the event handlers to.
handleEvents = (editor) ->
  buffer = editor.getBuffer()
  buffer.on 'will-be-saved', ->
    return if editor.getPath() is atom.config.getUserConfigPath()

    grammar = editor.getGrammar()
    switch atom.config.get([".#{grammar.scopeName}"], 'tabs-to-spaces.onSave')
      when 'untabify'
        loadModule()
        tabsToSpaces.untabify()
      when 'tabify'
        loadModule()
        tabsToSpaces.tabify()

# Internal: Loads the module on-demand.
loadModule = ->
  TabsToSpaces ?= require './tabs-to-spaces'
  tabsToSpaces ?= new TabsToSpaces()
