recentPaths = []

module.exports =
  configDefaults:
    maxRecentDirectories: 10
    updated: true # hacky, but gives a way to observe global changes

  activate: ->
    @maxRecentDirectories = atom.config.get('recent-files.maxRecentDirectories')
    @loadPaths()
    @insertCurrentPath()
    @createMenu(@createSubmenu())
    @addListeners()
    @savePaths()
    @markUpdatedAndListenForFutureUpdates()

  loadPaths: ->
    if localStorage['recentPaths']
      recentPaths = JSON.parse(localStorage['recentPaths'])

  savePaths: ->
    localStorage['recentPaths'] = JSON.stringify(recentPaths)

  insertCurrentPath: ->
    if atom.project.getRootDirectory()
      path = atom.project.getRootDirectory().path
      index = recentPaths.indexOf path
      if index != -1
        recentPaths.splice index, 1
      recentPaths.splice 0, 0, path
      if recentPaths.length > @maxRecentDirectories
        recentPaths.splice @maxRecentDirectories, recentPaths.length - @maxRecentDirectories

  createSubmenu: ->
    submenu = []
    for path in recentPaths
      index = recentPaths.indexOf path
      submenu.push { label: path, command: "recent-files:#{index}" }
    return { label: 'Recent', submenu: submenu }

  createMenu: (submenu) ->
    # need to place our menu in top section
    for dropdown in atom.menu.template
      if dropdown.label == "File"
        for item in dropdown.submenu
          if item.type == "separator"
            index = dropdown.submenu.indexOf(item)
            dropdown.submenu.splice index, 0, submenu
            atom.menu.update()
            break # break for item
        break # break for dropdown

  markUpdatedAndListenForFutureUpdates: ->
    # how do i do global events?
    atom.config.set('recent-files.updated', true)
    atom.config.observe 'recent-files.updated', =>
      if atom.config.get('recent-files.updated') == true
        atom.config.set('recent-files.updated', false)
        @removeListeners()
        @loadPaths()
        @addListeners()

  addListeners: ->
    for path in recentPaths
      index = recentPaths.indexOf path
      ((capturedPath, capturedIndex) ->
        atom.workspaceView.on "recent-files:#{capturedIndex}", =>
          atom.open({pathsToOpen:[capturedPath]})
      )(path, index)

  removeListeners: ->
    for path in recentPaths
      index = recentPaths.indexOf path
      atom.workspaceView.off "recent-files:#{index}"

  deactivate: ->
    @removeListeners()
