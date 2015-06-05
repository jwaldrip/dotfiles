{BufferedProcess, GitRepository} = require 'atom'
RepoListView = require './views/repo-list-view'
notifier = require './notifier'

# Public: Execute a git command.
#
# options - An {Object} with the following keys:
#   :args    - The {Array} containing the arguments to pass.
#   :cwd  - Current working directory as {String}.
#   :options - The {Object} with options to pass.
#   :stdout  - The {Function} to pass the stdout to.
#   :exit    - The {Function} to pass the exit code to.
#
# Returns nothing.
gitCmd = ({args, cwd, options, stdout, stderr, exit}={}) ->
  command = _getGitPath()
  options ?= {}
  options.cwd ?= cwd
  stderr ?= (data) -> notifier.addError data.toString()

  if stdout? and not exit?
    c_stdout = stdout
    stdout = (data) ->
      @save ?= ''
      @save += data
    exit = (exit) ->
      c_stdout @save ?= ''
      @save = null

  try
    new BufferedProcess
      command: command
      args: args
      options: options
      stdout: stdout
      stderr: stderr
      exit: exit
  catch error
    notifier.addError 'Git Plus is unable to locate git command. Please ensure process.env.PATH can access git.'

gitStatus = (repo, stdout) ->
  gitCmd
    args: ['status', '--porcelain', '-z']
    cwd: repo.getWorkingDirectory()
    stdout: (data) -> stdout(if data.length > 2 then data.split('\0') else [])

gitStagedFiles = (repo, stdout) ->
  files = []
  gitCmd
    args: ['diff-index', '--cached', 'HEAD', '--name-status', '-z']
    cwd: repo.getWorkingDirectory()
    stdout: (data) ->
      files = _prettify(data)
    stderr: (data) ->
      # edge case of no HEAD at initial commit
      if data.toString().includes "ambiguous argument 'HEAD'"
        files = [1]
      else
        notifier.addError data.toString()
        files = []
    exit: (code) -> stdout(files)

gitUnstagedFiles = (repo, {showUntracked}={}, stdout) ->
  gitCmd
    args: ['diff-files', '--name-status', '-z']
    cwd: repo.getWorkingDirectory()
    stdout: (data) ->
      if showUntracked
        gitUntrackedFiles(repo, _prettify(data), stdout)
      else
        stdout _prettify(data)

gitUntrackedFiles = (repo, dataUnstaged=[], stdout) ->
  gitCmd
    args: ['ls-files', '-o', '--exclude-standard','-z']
    cwd: repo.getWorkingDirectory()
    stdout: (data) ->
      stdout dataUnstaged.concat(_prettifyUntracked(data))

gitDiff = (repo, path, stdout) ->
  gitCmd
    args: ['diff', '-p', '-U1', path]
    cwd: repo.getWorkingDirectory()
    stdout: (data) -> stdout _prettifyDiff(data)

# Two-fold, refresh index as well as status
gitRefreshIndex = (repo=null)->
  if repo is null
    repo = GitRepository.open(atom.workspace.getActiveTextEditor()?.getPath(), refreshOnWindowFocus: false)
    repo.refreshStatus?()
    repo.destroy?()
  else
    repo.refreshStatus()
    atom.project.getRepositories()
      .filter (r) ->
        r.path is repo.path
      .forEach (r) ->
        r.refreshStatus()
  gitCmd
    args: ['add', '--refresh', '--', '.']
    stderr: (data) -> # don't really need to flash an error

gitAdd = (repo, {file, stdout, stderr, exit}={}) ->
  exit ?= (code) ->
    repo.destroy() if repo.destroyable
    if code is 0
      notifier.addSuccess "Added #{file ? 'all files'}"
  gitCmd
    args: ['add', '--all', file ? '.']
    cwd: repo.getWorkingDirectory()
    stdout: stdout if stdout?
    stderr: stderr if stderr?
    exit: exit

gitMerge = ({branchName, stdout, stderr, exit}={}) ->
  exit ?= (code) ->
    if code is 0
      notifier.addSuccess 'Git merged branch #{branchName} successfully'
  gitCmd
    args: ['merge', branchName],
    stdout: stdout if stdout?
    stderr: stderr if stderr?
    exit: exit

gitResetHead = (repo) ->
  gitCmd
    args: ['reset', 'HEAD']
    cwd: repo.getWorkingDirectory()
    stdout: (data) ->
      notifier.addSuccess 'All changes unstaged'
      repo.destroy() if repo.destroyable

_getGitPath = ->
  atom.config.get('git-plus.gitPath') ? 'git'

_prettify = (data) ->
  data = data.split('\0')[...-1]
  files = [] = for mode, i in data by 2
    {mode: mode, path: data[i+1]}

_prettifyUntracked = (data) ->
  return [] if not data?
  data = data.split('\0')[...-1]
  files = [] = for file in data
    {mode: '?', path: file}

_prettifyDiff = (data) ->
  data = data.split(/^@@(?=[ \-\+\,0-9]*@@)/gm)
  data[1..data.length] = ('@@' + line for line in data[1..])
  data

# Returns the working directory for a git repo.
# Will search for submodule first if currently
#   in one or the project root
#
# @param andSubmodules boolean determining whether to account for submodules
dir = (andSubmodules=true) ->
  new Promise (resolve, reject) ->
    if andSubmodules and submodule = getSubmodule()
      resolve(submodule.getWorkingDirectory())
    else
      getRepo().then (repo) -> resolve(repo.getWorkingDirectory())

# returns filepath relativized for either a submodule or repository
#   otherwise just a full path
relativize = (path) ->
  getSubmodule(path)?.relativize(path) ? atom.project.getRepositories()[0]?.relativize(path) ? path

# returns submodule for given file or undefined
getSubmodule = (path) ->
  path ?= atom.workspace.getActiveTextEditor()?.getPath()
  repo = GitRepository.open(atom.workspace.getActiveTextEditor()?.getPath(), refreshOnWindowFocus: false)
  submodule = repo?.repo.submoduleForPath(path)
  repo?.destroy?()
  submodule

# Public: Get the repository of the current file or project if no current file
# Returns a {Promise} that resolves to a repository like object
getRepo = ->
  new Promise (resolve, reject) ->
    repo = GitRepository.open(atom.workspace.getActiveTextEditor()?.getPath(), refreshOnWindowFocus: false)
    if repo isnt null
      repo.destroyable = true
      resolve(repo)
    else
      repos = atom.project.getRepositories().filter (r) -> r?
      if repos.length is 0
        reject("No repos found")
      else if repos.length > 1
        resolve(new RepoListView(atom.project.getRepositories()).result)
      else
        resolve(repos[0])

module.exports.cmd = gitCmd
module.exports.stagedFiles = gitStagedFiles
module.exports.unstagedFiles = gitUnstagedFiles
module.exports.diff = gitDiff
module.exports.refresh = gitRefreshIndex
module.exports.status = gitStatus
module.exports.reset = gitResetHead
module.exports.add = gitAdd
module.exports.dir = dir
module.exports.relativize = relativize
module.exports.getSubmodule = getSubmodule
module.exports.getRepo = getRepo
