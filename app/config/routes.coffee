module.exports = (app) ->
  {UsersController} = app.locals
  {pathRaw} = app.locals.path

  app.get pathRaw('index'), (req, res) ->
    res.render 'index', view: 'index'
