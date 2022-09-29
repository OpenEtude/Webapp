Prototip.Styles = {
  // The default style every other style will inherit from.
  // Used when no style is set through the options on a tooltip.
  'default': {
    border: 0,
    borderColor: '#AAAA99',
    className: 'etude',
    closeButton: true,
    hideAfter: false,
    hideOn: '.close',
    hook: false,
	images: 'styles/default/',    // Example: different images. An absolute url or relative to the images url defined above.
    radius: 0,
	showOn: 'mousemove',
    stem: {
      position: 'topMiddle',       // Example: optional default stem position, this will also enable the stem
      height: 12,
      width: 15
    }
  },

  'etude': {
    className: 'etude',
    border: 0,
    borderColor: 'none',
    radius: 0,
    stem: { height: 12, width: 15 }
  },


};