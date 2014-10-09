Knex = require 'knex'
Bluebird = require 'bluebird'
class PostgresClient
  constructor: ->
    knex = new Knex
      client: 'pg'
      connection: process.env.SUGAR_DB
      pool:
        min: 2
        max: 20
      migrations:
        extension: 'js'
        tableName: 'migrations'
        directory: '/migrations'
      debug: true
    
    for method in ['now', 'nowInterval', 'ago', 'fromNow', 'emptySet']
      knex[method] = this[method].bind knex
    
    return knex
  
  now: ->
    @raw "now() at time zone 'utc'"
  
  nowInterval: (sign, amount, unit) ->
    @raw "#{ @now() } #{ sign } interval '#{ amount }' #{ unit }"
  
  ago: (amount, unit) ->
    @nowInterval '-', amount, unit
  
  fromNow: (amount, unit) ->
    @nowInterval '+', amount, unit
  
  emptySet: ->
    deferred = Bluebird.defer()
    deferred.resolve []
    deferred.promise

module.exports = PostgresClient