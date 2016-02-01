{$, View} = require 'atom-space-pen-views'
{GitRepository} = require 'atom'

TravisCi = require 'travis-ci'

module.exports =
# Internal: The main view for displaying the status from Travis CI.
class BuildStatusView extends View
  # Internal: Build up the HTML contents for the fragment.
  @content: ->
    @div class: 'travis-ci-status inline-block', =>
      @span class: 'build-status icon icon-history', outlet: 'status', tabindex: -1, ''

  # Internal: Initialize the view.
  #
  # nwo    - The string of the repo owner and name.
  # matrix - The build matrix view.
  initialize: (@nwo, @matrix, @statusBar) ->
    atom.commands.add 'atom-workspace', 'travis-ci-status:toggle', => @toggle()
    this.on 'click', => @matrix.toggle()
    @attach()
    @subscribeToRepo()
    @update()

  # Internal: Serialize the state of this view.
  #
  # Returns an object containing key/value pairs of state data.
  serialize: ->

  # Internal: Attach the status bar segment to the status bar.
  #
  # Returns nothing.
  attach: ->
    @statusBarTile = @statusBar.addLeftTile(item: this, priority: 100)

  # Internal: Detach the status bar segment to the status bar.
  #
  # Returns nothing.
  detach: ->
    @statusBarTile?.destroy()

  # Internal: Destroy the view and tear down any state.
  #
  # Returns nothing.
  destroy: ->
    @detach()

  # Internal: Toggle the visibility of the view.
  #
  # Returns nothing.
  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  # Internal: Get the active pane item path.
  #
  # Returns a string of the file path, else undefined.
  getActiveItemPath: ->
    @getActiveItem()?.getPath?()

  # Internal: Get the active pane item.
  #
  # Returns an object for the pane item if it exists, else undefined.
  getActiveItem: ->
    atom.workspace.getActivePaneItem()

  # Internal: Subcribe to events on the projects repository object.
  #
  # Returns nothing.
  subscribeToRepo: =>
    @unsubscribe(@repo) if @repo?

    @repoPromise = Promise.all(
      atom.project.getDirectories().map(
        atom.project.repositoryForDirectory.bind(atom.project)
      ))

    @repoPromise.then (repos) =>
      name = atom.config.get('travis-ci-status.travisCiRemoteName')

      repo_list = repos.filter (r) ->
        /(.)*github\.com/i.test(r.getConfigValue("remote.#{name}.url"))

      @repo = repo_list[0]
      @repo.onDidChangeStatus(@update)

  # Internal: Update the repository build status from Travis CI.
  #
  # Returns nothing.
  update: =>
    return unless @hasParent()

    @status.addClass('pending')
    details = @nwo.split '/'

    updateRepo = =>
      return @status.removeClass('pending success fail') unless navigator.onLine

      atom.travis.repos(details[0], details[1]).get(@repoStatus)

    if atom.travis?.pro?
      token = atom.config.get('travis-ci-status.personalAccessToken')
      atom.travis.authenticate(github_token: token, updateRepo)
    else
      updateRepo()

  # Internal: Fallback to non-pro Travis CI.
  #
  # Returns nothing.
  fallback: ->
    atom.travis = new TravisCi(version: '2.0.0', pro: false)
    @update()

  # Internal: Callback for the Travis CI repository request, updates the build
  # status.
  #
  # err  - The error object if there was an error, else null.
  # data - The object of parsed JSON returned from the API.
  #
  # Returns nothing.
  repoStatus: (err, data) =>
    return @fallback() if err? and atom.travis?.pro?
    return if data['files'] is 'not found'
    return console.log "Error:", err if err?

    data = data['repo']
    @status.removeClass('pending success fail')

    if data and data['last_build_state'] is "passed"
      @matrix.update(data['last_build_id'])
      @status.addClass('success')
    else
      @status.addClass('fail')
