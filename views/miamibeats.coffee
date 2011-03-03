document.observe 'dom:loaded', ->
  beats = new MiamiBeats
  $('stopButton').on('click', (ev, el) ->
    beats.halt = 1
    el.hide()
    )

class MiamiBeats
  constructor: ->
    @fetcher.bind(this).delay 1
  fetcher: ->
    return if @halt == 1
    new Ajax.Request '/beats.json',
      method: 'get',
      onSuccess: (response) =>
        this.update response
    @fetcher.bind(this).delay 1
  update: (response) ->
    @beats = Number(response.responseJSON.beats)
    @date = new Date(Date.parse(response.responseJSON.date))
    this.setBeatView @beats.toFixed()
    this.setFractionView(@beats - @beats.toFixed())
    this.dateView().update @date.toLocaleDateString()
  setBeatView: (beats) ->
    @beatView ?= $('beats')
    @beatBar ?= $('beatBar')
    @beatView.update beats
    @beatBar.setStyle
      width: "#{beats / 10}%"
  setFractionView: (fraction) ->
    @fractionView ?= $('fractionalBeats')
    @fractionBar ?= $('fractionBar')
    @fractionView.update fraction
    @fractionBar.setStyle
      width: "#{fraction * 100}%"
  dateView: ->
    @dateElement ?= $('date')