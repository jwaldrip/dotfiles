fs = require 'fs-plus'
{$$, SelectListView} = require 'atom-space-pen-views'
git = require '../git'
notifier = require '../notifier'

module.exports =
class ListView extends SelectListView
  initialize: (@repo, @data) ->
    super
    @show()
    @parseData()
    @currentPane = atom.workspace.getActivePane()

  parseData: ->
    items = @data.split("\n")
    branches = []
    for item in items
      item = item.replace(/\s/g, '')
      unless item is ''
        branches.push {name: item}
    @setItems branches
    @focusFilterEditor()

  getFilterKey: -> 'name'

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()

    @storeFocusedElement()

  cancelled: -> @hide()

  hide: ->
    @panel?.destroy()

  viewForItem: ({name}) ->
    current = false
    if name.startsWith "*"
      name = name.slice(1)
      current = true
    $$ ->
      @li name, =>
        @div class: 'pull-right', =>
          @span('Current') if current

  confirmed: ({name}) ->
    @checkout name.match(/\*?(.*)/)[1]
    @cancel()

  checkout: (branch) ->
    git.cmd
      args: ['checkout', branch]
      cwd: @repo.getWorkingDirectory()
      # using `stderr` for success here
      stderr: (data) =>
        notifier.addSuccess data.toString()
        atom.workspace.observeTextEditors (editor) =>
          fs.exists editor.getPath().toString(), (exists) =>
            editor.destroy() if not exists
            @repo.destroy() if @repo.destroyable
        git.refresh @repo
        @currentPane.activate()
