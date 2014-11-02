# CHANGELOG

## **v0.7.1** &mdash; *Released: 22 October 2014*

* [#11](https://github.com/lee-dohm/tabs-to-spaces/issues/11) - Disable onSave tabification or untabification of `config.cson`

## **v0.7.0** &mdash; *Released: 17 October 2014*

* Add support for language-specific configuration for `onSave` [#9](https://github.com/lee-dohm/tabs-to-spaces/issues/9)
* Skipped v0.6.0 due to publishing issue

## **v0.5.1** &mdash; *Released: 5 October 2014*

* Use new configuration schema to turn the `onSave` setting into a dropdown

## **v0.5.0** &mdash; *Released: 3 October 2014*

* :bug: Fix [#7](https://github.com/lee-dohm/tabs-to-spaces/issues/7) - Handles any mixture of tabs or spaces at the beginning of lines

## **v0.4.2** &mdash; *Released: 29 July 2014*

* :bug: Fix [#5](https://github.com/lee-dohm/tabs-to-spaces/issues/5) - Remove dependency on `fs-plus` because it was generating some sort of strange build error

## **v0.4.1** &mdash; *Released: 21 July 2014*

* [#4](https://github.com/lee-dohm/tabs-to-spaces/pull/4) by [@Zren](https://github.com/Zren) - Add default value for `onSave` so that it always shows up in the Settings View

## **v0.4.0** &mdash; *Released: 28 June 2014*

* Add support for editor-specific tab length settings [#1](https://github.com/lee-dohm/tabs-to-spaces/issues/1)

## **v0.3.4** &mdash; *Released: 25 May 2014*

* :bug: Fix [#2](https://github.com/lee-dohm/tabs-to-spaces/issues/2) - Dereference of `null` in `handleEvents()`

## **v0.3.3** &mdash; *Released: 24 May 2014*

* :bug: Fixed the on save event handlers
