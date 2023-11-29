## hold_to_confirm_button

**I am trying to create a Flutter package** :relaxed::relaxed::relaxed:
**Let's create a package for a Flutter project.** :tada::tada::tada:

The `hold_to_confirm_button`  is a button for confirming action with a hold press to animation in a long-press format with animation progress. this package will not be published it on **pub.dev**

## Todo List

- [ ] Fixed the text button can't be flexible
- [ ] Add custom properties
- [ ] Add new style
- [ ] Add text animation effect
- [ ] Separates the business logic from the UI
- [ ] Clean source code


## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:
```yaml

dependencies:
  ...
  hold_to_confirm_button: #just sample, package is not published.
  
```
Import it:
```dart

import 'package:hold_to_confirm_button/hold_to_confirm_button.dart'; 

```

## Usage


```dart

HoldToConfirmButton(
  text: 'Public',
  holdingText: 'Sure?',
  height: 64.0, // default: 48.0
  timeCount: 5000, // default: 2000, duration of long-press action => Duration(milliseconds: widget.timeCount).
  timeDelayedCompleted: 500, // default: 500, Delay time before next action or [onCompleted].
  onHold: (bool holding)) { // Not Required
    // When starting the animation 'onTapDown' returns true, or false when the animation is reversed.
  },
  onCompleted: () { // Required
    // Fired when an animation has completed.
  },
),

```  
  