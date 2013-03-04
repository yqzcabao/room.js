module.exports = class EditorInterface

  constructor: (@db) ->

  objects: ->
    objects = @db.objectsAsArray()
    objects[0...objects.length-3]

  objectsTree: ->
    aliases = @db.globalAliases()

    objects = @objects()

    children = (o) =>
      child_os = objects.filter (other_o) ->
        other_o.parent_id == o.id
      child_os.map show

    show = (o) ->
      x =
        id: o.id
        name: o.name
        player: o.player
      if aliases[o.id]?
        x.alias = aliases[o.id]
      x.children = children o
      x

    top = objects.filter (o) ->
      o.parent_id == null

    top.map show

  getObject: (id) ->
    object = @db.findById id
    alias = @db.aliasFor id
    {
      id: object.id
      name: object.name
      alias: alias
      properties: object.getOwnProperties()
      verbs: object.getOwnVerbs()
    }

  saveProperty: (property) ->
    @db.findById(property.object_id).setProp property.key, property.value