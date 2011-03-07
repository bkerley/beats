(function() {
  var MiamiBeats;
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  document.observe('dom:loaded', function() {
    var beats;
    beats = new MiamiBeats();
    return $('stopButton').on('click', function(ev, el) {
      beats.halt = 1;
      return el.hide();
    });
  });
  MiamiBeats = function() {
    this.fetcher.bind(this).delay(1);
    return this;
  };
  MiamiBeats.prototype.fetcher = function() {
    if (this.halt === 1) {
      return null;
    }
    new Ajax.Request('/beats.json', {
      method: 'get',
      onSuccess: __bind(function(response) {
        return this.update(response);
      }, this)
    });
    return this.fetcher.bind(this).delay(1);
  };
  MiamiBeats.prototype.update = function(response) {
    this.beats = Number(response.responseJSON.beats);
    this.date = new Date(Date.parse(response.responseJSON.date));
    this.setBeatView(this.beats);
    this.setFractionView(this.beats - Math.floor(this.beats));
    return this.dateView().update(this.date.toLocaleDateString());
  };
  MiamiBeats.prototype.setBeatView = function(beats) {
    this.beatView = (typeof this.beatView !== "undefined" && this.beatView !== null) ? this.beatView : $('beats');
    this.beatBar = (typeof this.beatBar !== "undefined" && this.beatBar !== null) ? this.beatBar : $('beatBar');
    this.beatView.update(Math.floor(beats));
    return this.beatBar.setStyle({
      width: ("" + (beats / 10.0) + "%")
    });
  };
  MiamiBeats.prototype.setFractionView = function(fraction) {
    this.fractionView = (typeof this.fractionView !== "undefined" && this.fractionView !== null) ? this.fractionView : $('fractionalBeats');
    this.fractionBar = (typeof this.fractionBar !== "undefined" && this.fractionBar !== null) ? this.fractionBar : $('fractionBar');
    this.fractionView.update(Math.round(fraction * 1000) / 1000);
    return this.fractionBar.setStyle({
      width: ("" + (fraction * 100) + "%")
    });
  };
  MiamiBeats.prototype.dateView = function() {
    return this.dateElement = (typeof this.dateElement !== "undefined" && this.dateElement !== null) ? this.dateElement : $('date');
  };
})();
