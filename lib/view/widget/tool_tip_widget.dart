import 'package:flutter/material.dart';
import 'package:nas/core/constant/theme.dart';

class ToolTipIcon extends StatefulWidget {
  final String message;
  final String imagePath;
  const ToolTipIcon({
    super.key,
    required this.message,
    required this.imagePath,
  });

  @override
  State<ToolTipIcon> createState() => _ToolTipIconState();
}

class _ToolTipIconState extends State<ToolTipIcon> {
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  void _showTooltip() {
    final dynamic tooltip = _tooltipKey.currentState;
    tooltip?.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTooltip,
      child: SizedBox(
        height: 20,
        width: 20,
        child: Column(
          children: [
            Tooltip(
              key: _tooltipKey,
              message: widget.message,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              preferBelow: false,
              verticalOffset: 4,
              showDuration: Duration(seconds: 2),
              margin: EdgeInsets.only(left: 50),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              textStyle: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              child: Image.asset(
                widget.imagePath,
                height: 16,
                width: 16,
                fit: BoxFit.scaleDown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
