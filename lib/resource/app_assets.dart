abstract class AppAssets {
  // audio assets
  static const _audioBase = 'assets/audio';
  // theme music
  static const planetThemeMusic = '$_audioBase/planet_theme_music.mp3';
  // button click
  static const buttonClick = '$_audioBase/button_click.mp3';
  // visibility show
  static const visibility = '$_audioBase/visibility.mp3';
  // count down begin
  static const countDownBegin = '$_audioBase/count_down_begin.mp3';
  // completion
  static const completion = '$_audioBase/completion.mp3';
  // tile tap
  static const tileTapSuccess = '$_audioBase/tile_tap_success.mp3';
  static const tileTapError = '$_audioBase/tile_tap_error.mp3';

  // image assets
  static const _imageBase = 'assets/images';

  // loading screen images
  static const planetsImage = '$_imageBase/planets.png';

  // dashboard images
  static const sunImage = '$_imageBase/sun.png';

  // planets
  static const _planetsBase = 'assets/planets';

  // earth
  static const _earthBase = '$_planetsBase/earth';
  static const earthImage = '$_earthBase/earth.png';
  static const earthThumb = '$_earthBase/earth_thumb.png';
  static const earthAnimation = '$_earthBase/earth.riv';
  static const earthLandscape = '$_earthBase/earth_landscape.png';

  // jupiter
  static const _jupiterBase = '$_planetsBase/jupiter';
  static const jupiterImage = '$_jupiterBase/jupiter.png';
  static const jupiterThumb = '$_jupiterBase/jupiter_thumb.png';
  static const jupiterAnimation = '$_jupiterBase/jupiter.riv';
  static const jupiterLandscape = '$_jupiterBase/jupiter_landscape.png';

  // mars
  static const _marsBase = '$_planetsBase/mars';
  static const marsImage = '$_marsBase/mars.png';
  static const marsThumb = '$_marsBase/mars_thumb.png';
  static const marsAnimation = '$_marsBase/mars.riv';
  static const marsLandscape = '$_marsBase/mars_landscape.png';

  // mercury
  static const _mercuryBase = '$_planetsBase/mercury';
  static const mercuryImage = '$_mercuryBase/mercury.png';
  static const mercuryThumb = '$_mercuryBase/mercury_thumb.png';
  static const mercuryAnimation = '$_mercuryBase/mercury.riv';
  static const mercuryLandscape = '$_mercuryBase/mercury_landscape.png';

  // neptune
  static const _neptuneBase = '$_planetsBase/neptune';
  static const neptuneImage = '$_neptuneBase/neptune.png';
  static const neptuneThumb = '$_neptuneBase/neptune_thumb.png';
  static const neptuneAnimation = '$_neptuneBase/neptune.riv';
  static const neptuneLandscape = '$_neptuneBase/neptune_landscape.png';

  // pluto
  static const _plutoBase = '$_planetsBase/pluto';
  static const plutoImage = '$_plutoBase/pluto.png';
  static const plutoThumb = '$_plutoBase/pluto_thumb.png';
  static const plutoAnimation = '$_plutoBase/pluto.riv';
  static const plutoLandscape = '$_plutoBase/pluto_landscape.png';

  // saturn
  static const _saturnBase = '$_planetsBase/saturn';
  static const saturnImage = '$_saturnBase/saturn.png';
  static const saturnExtra = '$_saturnBase/saturn_extra.png';
  static const saturnExtraThumb = '$_saturnBase/saturn_extra_thumb.png';
  static const saturnThumb = '$_saturnBase/saturn_thumb.png';
  static const saturnAnimation = '$_saturnBase/saturn.riv';
  static const saturnLandscape = '$_saturnBase/saturn_landscape.png';

  // uranus
  static const _uranusBase = '$_planetsBase/uranus';
  static const uranusImage = '$_uranusBase/uranus.png';
  static const uranusThumb = '$_uranusBase/uranus_thumb.png';
  static const uranusAnimation = '$_uranusBase/uranus.riv';
  static const uranusLandscape = '$_uranusBase/uranus_landscape.png';

  // venus
  static const _venusBase = '$_planetsBase/venus';
  static const venusImage = '$_venusBase/venus.png';
  static const venusThumb = '$_venusBase/venus_thumb.png';
  static const venusAnimation = '$_venusBase/venus.riv';
  static const venusLandscape = '$_venusBase/venus_landscape.png';

  // we keep the following lists for caching

  static const assetsToPreFetch = [
    sunImage,
    earthThumb,
    jupiterThumb,
    marsThumb,
    mercuryThumb,
    neptuneThumb,
    plutoThumb,
    saturnThumb,
    uranusThumb,
    venusThumb,
  ];

  static const animationAssetsToPrefetch = [
    earthAnimation,
    jupiterAnimation,
    marsAnimation,
    mercuryAnimation,
    neptuneAnimation,
    plutoAnimation,
    saturnAnimation,
    uranusAnimation,
    venusAnimation,
  ];

  static const extraAssetsToPrefetch = [
    earthImage,
    earthLandscape,
    jupiterImage,
    jupiterLandscape,
    marsImage,
    marsLandscape,
    mercuryImage,
    mercuryLandscape,
    neptuneImage,
    neptuneLandscape,
    plutoImage,
    plutoLandscape,
    saturnImage,
    saturnLandscape,
    saturnExtra,
    saturnExtraThumb,
    uranusImage,
    uranusLandscape,
    venusImage,
    venusLandscape,
  ];
}
