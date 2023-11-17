library button_hold_to_confirm;

import 'package:flutter/material.dart';

import 'package:hold_to_confirm_button/custom_timer_painter.dart';
import 'package:hold_to_confirm_button/constants.dart';
import 'package:hold_to_confirm_button/themes/style.dart';

class HoldToConfirmButton extends StatefulWidget {
  const HoldToConfirmButton({
    Key? key,
    required this.onCompleted,
    this.onHold,
    this.height = 48.0,
    this.size,
    this.timeCount = 2000,
    this.timeDelayedCompleted = 500,
    this.text = "Confirm",
    this.holdingText = "Sure?",
  }) : super(key: key);

  /// Required
  final void Function() onCompleted;

  /// Not-Required
  final void Function(bool holding)? onHold;
  final double height;
  final HoldToConfirmButtonSize? size;
  final int timeCount;
  final int timeDelayedCompleted;
  final String text;
  final String holdingText;

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  LoadingState state = LoadingState.init;
  PadState padState = PadState.init;
  EdgeInsets padValue = const EdgeInsets.all(0.0);
  EdgeInsets padDoneValue = const EdgeInsets.all(0.0);
  bool isHold = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.timeCount),
    );
    _controller.addListener(_handleProgressingAnimation);
    _resetAnimation();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleProgressingAnimation);
    _controller.dispose();
    super.dispose();
  }

  void _handleProgressingAnimation() {
    if (state == LoadingState.holding && !isHold) {
      setState(() {
        widget.onHold?.call(true);
        isHold = true;
      });
    }

    // NOTE: Reverse Animation
    if (!_controller.isAnimating &&
        !_controller.isCompleted &&
        state == LoadingState.holding) {
      setState(() {
        widget.onHold?.call(false);
        isHold = false;
        state = LoadingState.init;
        padValue = const EdgeInsets.all(0.0);
      });
    }

    // NOTE: Completed Animation
    if (!_controller.isAnimating &&
        _controller.isCompleted &&
        state == LoadingState.holding) {
      setState(() {
        padDoneValue = EdgeInsets.symmetric(
          vertical: (_buttonHeight / 2),
          horizontal: kFontSize4XL * 2,
        );
      });
    }

    setState(() {});
  }

  void _resetAnimation() {
    setState(() {
      padState = PadState.init;
      state = LoadingState.init;
      padValue = const EdgeInsets.all(0.0);
      padDoneValue = const EdgeInsets.all(0.0);
      _controller.reset();
    });
  }

  double get _buttonHeight {
    switch (widget.size) {
      case HoldToConfirmButtonSize.xs:
        return 32.0;
      case HoldToConfirmButtonSize.small:
        return 40.0;
      case HoldToConfirmButtonSize.medium:
        return 48.0;
      case HoldToConfirmButtonSize.large:
        return 56.0;
      default:
        return widget.height;
    }
  }

  Widget get _textWidget {
    const textStyle = TextStyle(
      color: kColorWhite,
      fontSize: kFontSizeM,
      fontWeight: FontWeight.w600,
    );
    switch (padState) {
      case PadState.init:
        return Text(widget.text, style: textStyle);
      case PadState.holding:
        return Text(widget.holdingText, style: textStyle);
      case PadState.done:
        return const Icon(Icons.done, color: kColorWhite, size: kFontSize4XL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapCancel: () {
        if (_controller.status == AnimationStatus.forward) {
          _controller.reverse();
        }
      },
      onTapDown: (_) {
        setState(() {
          if (state != LoadingState.done) {
            state = LoadingState.holding;
            padValue = const EdgeInsets.all(4.0);
            _controller.forward();
          }
        });
      },
      onTapUp: (_) {
        if (_controller.status == AnimationStatus.forward) {
          _controller.reverse();
        }
      },
      child: Container(
        height: _buttonHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: kColorPrimaryDark,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.ltr,
          children: [
            _buildInitBackground(),
            _buildAnimatedCustomPaint(),
            _buildAnimatedBackground(),
            Directionality(
              textDirection: TextDirection.ltr,
              child: _textWidget,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCustomPaint() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            isComplex: true,
            willChange: true,
            painter: CustomTimerPainter(
              animation: _controller,
              color: kColorWhite.withOpacity(0.65),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    final isHolding = state == LoadingState.holding;
    final bg = isHolding ? _buildHoldingBackground() : _buildInitBackground();

    return AnimatedPadding(
      duration: animationDuration,
      padding: padValue,
      curve: Curves.easeInOut,
      onEnd: () {
        if (padState == PadState.init && state == LoadingState.holding) {
          setState(() => padState = PadState.holding);
        }
        if (padState == PadState.holding && state == LoadingState.init) {
          setState(() => padState = PadState.init);
        }
      },
      child: bg,
    );
  }

  Widget _buildInitBackground() {
    final isDone = state == LoadingState.done;
    return Container(
      key: isDone ? const ValueKey('HCB-03') : const ValueKey('HCB-01'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: kColorPrimaryDark,
        borderRadius: BorderRadius.circular(5.0),
        gradient: kGradientColorLinearLeft,
      ),
    );
  }

  Widget _buildHoldingBackground() {
    final padDone = padState == PadState.done;
    final padHolding = padState == PadState.holding;
    return AnimatedPadding(
      duration: animationDuration,
      padding: padDoneValue,
      curve: Curves.easeInOut,
      onEnd: () {
        if (!_controller.isAnimating && _controller.isCompleted && !padDone) {
          setState(() {
            padState = PadState.done;
            state = LoadingState.done;
            Future.delayed(
              Duration(milliseconds: widget.timeDelayedCompleted),
              () => widget.onCompleted.call(),
            );
          });
        }
      },
      child: AnimatedOpacity(
        duration: animationDuration,
        opacity: padDone ? 0 : 1,
        child: Container(
          key: const ValueKey('HCB-02'),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: kColorPrimaryDark,
            borderRadius: BorderRadius.circular(5.0),
            gradient: padHolding ? null : kGradientColorLinearLeft,
          ),
        ),
      ),
    );
  }
}
