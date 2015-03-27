document.observe 'dom:loaded', ->
  beats = new MiamiBeats
  $('stopButton').on('click', (ev, el) ->
    beats.halt = 1
    el.hide()
  )

class MiamiBeats
  constructor: ->
    @beatView ?= $('beats')
    @beatBar ?= $('beatBar')
    @dateElement ?= $('date')
    @fetch()()
  fetch: ->
    @fetchFun ||= ()=>
      return if @halt == 1
      new Ajax.Request '/beats.json',
        method: 'get',
        onSuccess: (response) =>
          @update response
          @fetch().delay 30
  update: (response) ->
    rj = response.responseJSON
    @beats = Number(rj.beats)
    @beatsAt = new Date()
    @date = new Date(rj.date)
    @refresh() unless @running?
  refresh: ->
    @running = true
    cb = @currentBeats()
    @setDate()
    @setBeatView cb
    @setBeatBar cb
    @setFractionView(cb - Math.floor(cb))
    window.requestAnimationFrame @refresh.bind(this)
  currentBeats: ()->
    now = new Date()
    msDiff = now - @beatsAt
    msPerDay = 1000 * 60 * 60 * 24
    beatsPerDay = 1000
    beatsDiff = (msDiff / msPerDay) * beatsPerDay
    @beats + beatsDiff
  setDate: () ->
    return unless @date?
    @dateElement.update @date.toLocaleDateString "en-US",
      weekday: 'long'
      month: 'long'
      day: 'numeric'
      year: 'numeric'
  setBeatBar: (beats) ->
    @beatBar.setStyle
      width: "#{beats / 10.0}%"
  setBeatView: (beats) ->
    @beatView.update Math.floor(beats)
    @beatBar.setStyle
      width: "#{beats / 10.0}%"
  setFractionView: (fraction) ->
    @fractionView ?= $('fractionalBeats')
    @fractionBar ?= $('fractionBar')
    @fractionView.update Math.round(fraction * 1000)/1000
    @fractionBar.setStyle
      width: "#{fraction * 100}%"
